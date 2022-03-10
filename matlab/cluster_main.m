clc, clear, close all

NUM_POINTS = 10;
SEED = 1;

SUCCESS_RANGES = [0 40
                  0 40];
FAILURE_RANGES = [80 100
                  80 100];
              
PROBLEM_DIM = max(size(SUCCESS_RANGES, 1), size(FAILURE_RANGES, 1));

%% generate successes and failures
success_generator = PointGenerator(PROBLEM_DIM, SUCCESS_RANGES, SEED);
failure_generator = PointGenerator(PROBLEM_DIM, FAILURE_RANGES, SEED);
 
successes = generate_points(success_generator, NUM_POINTS);
failures = generate_points(failure_generator, NUM_POINTS);

% successes = [1 3 2;
%              0 0 665];
% failures = [1.5 2 2.5
%             0   0  0];

s_points = [];
f_points = [];
for k = 1:size(successes,2)
    s_points = [s_points Cluster("points", successes(:,k), "success")];
end
for k = 1:size(failures,2)
    f_points = [f_points Cluster("points", failures(:,k), "failure")];
end

clusters = cluster([s_points f_points])

f = figure;
f.Position = [542 158 929 675];

% failure landspace
hold on

plot_points(successes, 'blue', 36, 0.7)
plot_points(failures, 'red', 36, 0.7)
