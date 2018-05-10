%% Reading the data from the file
dataFile = 'vibration_data.xlsx';
data = xlsread(dataFile);
rng(0);

%% Extracting the data from the file
horizontalDistance = data(:,2).';
soilThickness = data(:,3).';
strataThickness = data(:,4).';
explosiveDistance = data(:,5).';
cutholeDepth = data(:,6).';
maxCharge = data(:,7).';
peripheralCharge = data(:,8).';
totalCharge = data(:,9).';
vibration = data(:,10).';

%% Constructing the NN
net = feedforwardnet([4,4]);

%% Setting up training
net.trainParam.show = 50;
net.trainParam.lr = 0.05;
net.trainParam.mc = 0.95;
net.trainParam.epochs = 1000;
net.trainParam.goal=1e-10;
%net.trainParam.min_grad = 1e-100;
%net.trainParam.mu = 1e-100;
net.trainParam.max_fail = 1000; % Validation check counts

%% Start training the NN
net = train(net,[horizontalDistance(1:40);soilThickness(1:40);strataThickness(1:40);explosiveDistance(1:40);cutholeDepth(1:40);maxCharge(1:40);peripheralCharge(1:40);totalCharge(1:40)],[vibration(1:40)]);

%% Saving the netork
save step1 net

%% Testing the training results on 10 datapoints

a = sim(net, [horizontalDistance(1,31:40);soilThickness(1,31:40);strataThickness(1,31:40);explosiveDistance(1,31:40);cutholeDepth(1,31:40);maxCharge(1,31:40);peripheralCharge(1,31:40);totalCharge(1,31:40)]);


%%

figure(1)
plot(a(1,:),'b-o', 'LineWidth',1);
hold on
plot(vibration(1,31:40),'r+-','LineWidth',1);
hold off
legend('NN output', 'Actual reading');
grid