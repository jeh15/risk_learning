clc, clear, close all

NUM_POINTS = 1000000;
NUM_BINS = 7;
SEED = 1;

SUCCESS_RANGES = [0 70
                  0 70
                  0 70
                  0 70
                  0 70
                  0 70
                  0 70];
FAILURE_RANGES = [30 100
                  30 100
                  30 100
                  30 100
                  30 100
                  30 100
                  30 100];
              
PROBLEM_DIM = max(size(SUCCESS_RANGES, 1), size(FAILURE_RANGES, 1));

%% generate successes and failures
% success_generator = PointGenerator(PROBLEM_DIM, SUCCESS_RANGES, SEED);
% failure_generator = PointGenerator(PROBLEM_DIM, FAILURE_RANGES, SEED);
% 
% successes = generate_points(success_generator, NUM_POINTS);
% failures = generate_points(failure_generator, NUM_POINTS);

successes = load('successes').successes;
failures = load('failures').failures;

points = [successes failures];

%% compute centroids
tic % =================>

c_successes = centroid(successes);
c_failures = centroid(failures);

%% project points
u = unitvector(c_successes, c_failures);

projected_successes = project(successes - c_successes, u) + c_successes;
projected_failures = project(failures - c_failures, u) + c_failures;

projected_points = [projected_successes projected_failures];

%% compute extreme points
[~, e1_index] = max(distance(projected_points, c_failures));
e1 = projected_points(:, e1_index);

[~, e2_index] = max(distance(projected_points, c_successes));
e2 = projected_points(:, e2_index);

%% setup bins
epsilon = 0.000000001;
max_distance = distance(e1, e2) + epsilon;
bin_size = max_distance / NUM_BINS;

success_bin_nums = floor(distance(projected_successes, e1) / bin_size) + 1;
failure_bin_nums = floor(distance(projected_failures, e1) / bin_size) + 1;


bins = [ones(NUM_BINS, 1)*epsilon zeros(NUM_BINS, 1)];
for k = 1:NUM_POINTS
    bins(success_bin_nums(k), 1) = bins(success_bin_nums(k), 1) + 1;
    bins(failure_bin_nums(k), 2) = bins(failure_bin_nums(k), 2) + 1;
end

%% computer failure probabilties
distances = bin_size * [0 : NUM_BINS];
avg_distances = (distances(1:end-1) + distances(2:end)) / 2;
failure_probability = bins(:,2) ./ (bins(:,1) + bins(:,2));

toc % <=================
return

%% Draw
f = figure;
f.Position = [542 158 929 675];

% failure landspace
subplot(1,2,1)
hold on

plot_points(successes, 'blue', 36, 0.7)
plot_points(failures, 'red', 36, 0.7)
plot_points(c_successes, 'blue', 100, 1)
plot_points(c_failures, 'red', 100, 1)
plot_points(projected_successes, 'blue', 36, 0.2)
plot_points(projected_failures, 'red', 36, 0.2)

plot_line(e1, e2, 'black', '--', 1.5, 0.2)

for k = 1:NUM_POINTS
    plot_line(successes(:,k), projected_successes(:,k), 'blue', ':', 1.5, 0.2)
end

for k = 1:NUM_POINTS
    plot_line(failures(:,k), projected_failures(:,k), 'red', ':', 1.5, 0.2)
end

axis equal
grid on

% failure probability function
subplot(1,2,2)
plot(avg_distances, failure_probability, '-r', 'LineWidth', 2)