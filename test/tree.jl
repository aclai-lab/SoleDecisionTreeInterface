using Test

using MLJ
using MLJBase
using DataFrames

using MLJDecisionTreeInterface
using SoleDecisionTreeInterface
using BenchmarkTools
using Sole

X, y = @load_iris
X = DataFrame(X)

train_ratio = 0.8

train, test = partition(eachindex(y), train_ratio, shuffle=true)
X_train, y_train = X[train, :], y[train]
X_test, y_test = X[test, :], y[test]

println("Training set size: ", size(X_train), " - ", size(y_train))
println("Test set size: ", size(X_test), " - ", size(y_test))
println("Training set type: ", typeof(X_train), " - ", typeof(y_train))
println("Test set type: ", typeof(X_test), " - ", typeof(y_test))

Tree = MLJ.@load DecisionTreeClassifier pkg=DecisionTree

model = Tree(
  max_depth=-1,
  min_samples_leaf=1,
  min_samples_split=2,
)

# Bind the model and data into a machine
mach = machine(model, X_train, y_train)
# Fit the model
fit!(mach)


sole_dt = solemodel(fitted_params(mach).tree)

@test SoleData.scalarlogiset(X_test; allow_propositional = true) isa PropositionalLogiset

# Make test instances flow into the model
apply!(sole_dt, X_test, y_test)

# apply!(sole_dt, X_test, y_test, mode = :append)

sole_dt = @test_nowarn @btime solemodel(fitted_params(mach).tree, true)
sole_dt = @test_nowarn @btime solemodel(fitted_params(mach).tree, false)

printmodel(sole_dt; max_depth = 7, show_intermediate_finals = true, show_metrics = true)

printmodel.(listrules(sole_dt, min_lift = 1.0, min_ninstances = 0); show_metrics = true);

printmodel.(listrules(sole_dt, min_lift = 1.0, min_ninstances = 0); show_metrics = true, show_subtree_metrics = true);

printmodel.(listrules(sole_dt, min_lift = 1.0, min_ninstances = 0); show_metrics = true, show_subtree_metrics= true, tree_mode=true);

readmetrics.(listrules(sole_dt; min_lift=1.0, min_ninstances = 0))

printmodel.(listrules(sole_dt, min_lift = 1.0, min_ninstances = 0); show_metrics = true);

interesting_rules = listrules(sole_dt; min_lift=1.0, min_ninstances = 0, custom_thresholding_callback = (ms)->ms.coverage*ms.ninstances >= 4)
# printmodel.(sort(interesting_rules, by = readmetrics); show_metrics = (; round_digits = nothing, ));
printmodel.(sort(interesting_rules, by = readmetrics); show_metrics = (; round_digits = nothing, additional_metrics = (; length = r->natoms(antecedent(r)))));

@test_broken joinrules(interesting_rules) == "Check this result."
