clc, clear, close all

NUM_POINTS = 1000000;

NUM_BINS = 7;
epsilon = 0.000000001;

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
SEED = 1;

% success_generator = PointGenerator(PROBLEM_DIM, SUCCESS_RANGES, SEED);
% failure_generator = PointGenerator(PROBLEM_DIM, FAILURE_RANGES, SEED);
% 
% successes = generate_points(success_generator, NUM_POINTS);
% failures = generate_points(failure_generator, NUM_POINTS);

successes = load('successes').successes;
failures = load('failures').failures;

points = [successes failures];

%% find extreme points
tic % =================>

[~, emin_indices] = min(points, [], 2);
emin = diag(points(:, emin_indices));

[~, emax_indices] = max(points, [], 2);
emax = diag(points(:, emax_indices));

%% setup bins
bin_size = (emax - emin + epsilon) / NUM_BINS;
ss = floor((successes - emin) ./ bin_size) + 1;
ff = floor((failures - emin) ./ bin_size) + 1;

success_bins = epsilon*ones(NUM_BINS * ones(1, PROBLEM_DIM));
failure_bins = zeros(NUM_BINS * ones(1, PROBLEM_DIM));
for k = 1:NUM_POINTS    
    success_bins(ss(1,k), ss(2,k), ss(3,k), ss(4,k), ss(5,k), ss(6,k), ss(7,k)) = ...
        success_bins(ss(1,k), ss(2,k), ss(3,k), ss(4,k), ss(5,k), ss(6,k), ss(7,k)) + 1;
    
    failure_bins(ff(1,k), ff(2,k), ff(3,k), ff(4,k), ff(5,k), ff(6,k), ff(7,k)) = ...
        failure_bins(ff(1,k), ff(2,k), ff(3,k), ff(4,k), ff(5,k), ff(6,k), ff(7,k)) + 1;
end

%% compute function
distances = bin_size * [0:NUM_BINS];
avg_distances = (distances(:,1:end-1) + distances(:,2:end)) ./ 2;
failure_probabilities = failure_bins ./ (success_bins + failure_bins);

toc % <=================
return

X = cartesian_product(avg_distances);
F = griddedInterpolant(X{:}, failure_probabilities, 'cubic');

temp = [];
for m = 1:NUM_BINS
    for n = 1:NUM_BINS
        for o = 1:NUM_BINS
            temp(m,n,o) = F(X{1}(m,n,o), X{2}(m,n,o), X{3}(m,n,o));
        end
    end
end
all(all(temp == failure_probabilities));

%% draw
f = figure;
f.Position = [147 122 1697 734];

subplot(1,2,1)
hold on
plot_points(successes, 'blue', 15, 1)
plot_points(failures, [0.9290 0.6940 0.1250], 15, 1)

if NUM_POINTS < 20
    if size(points, 1) == 2
        text(points(1,:), points(2,:), ' '+string([1:2*NUM_POINTS]), ...
            'FontWeight', 'bold', 'FontSize', 11)
    elseif size(points, 1) == 3
        text(points(1,:), points(2,:), points(3,:), ' '+string([1:2*NUM_POINTS]), ...
            'FontWeight', 'bold', 'FontSize', 11)
    end
end

x_distances = bin_size(1) * [0:NUM_BINS];
y_distances = bin_size(2) * [0:NUM_BINS];
for k = 1:numel(x_distances)
    xline(emin(1)+x_distances(k), 'b:', 'LineWidth', 1.5)
    yline(emin(2)+y_distances(k), 'b:', 'LineWidth', 1.5)
end

if PROBLEM_DIM == 3
    view(3)
    grid on
    xlabel('x')
    ylabel('y')
    zlabel('z')
end

% draw function
if PROBLEM_DIM ==2
    subplot(1,2,2)
    [XX, YY] = meshgrid([0:0.5:100], [0:0.5:100]);
%     surf(X{1}, X{2}, temp)
    surf(XX', YY', F(XX', YY'))
    view(2)
elseif PROBLEM_DIM ==3
    subplot(1,2,2)
    hold on
    [XX, YY, ZZ] = meshgrid([0:5:100], [0:5:100], [0:5:100]);
    points = [XX(:), YY(:), ZZ(:)];
    failure_prob = (F(points) - min(F(points))) / (max(F(points)) - min(F(points)));
    sz = size(failure_prob);
    c = (1-failure_prob).*[ones(sz) ones(sz) ones(sz)];
    for k = 1:5:size(points, 1)
        plot3(points(k,1), points(k,2), points(k,3), '.', 'color', c(k,:), 'MarkerSize', 10)
    end
    for k = 1:numel(x_distances)
    xline(emin(1)+x_distances(k), 'b:', 'LineWidth', 1.5)
    yline(emin(2)+y_distances(k), 'b:', 'LineWidth', 1.5)
end
    view(3)
    grid on
    xlabel('x')
    ylabel('y')
    zlabel('z')
end