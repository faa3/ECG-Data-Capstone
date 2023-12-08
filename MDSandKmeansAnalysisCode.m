% This script will read information of pairwise distances and will compute the MDS and kmeans algorithm on the distance.

euclideanDir = 'c:\Users\faa3\Documents\Distance\EuclideanDistances';
wassDir = 'c:\Users\faa3\Documents\Distance\Wasserstein Distances';
labelDir = 'c:\Users\faa3\Documents\Distance\Labels';
interest = [21,20,15,14,12,10,7,6,3,1]; % List of predefined patients
k=1;
j =1;
% Compute MDS per patient.
for i=1:21
    
    eucPath = strcat(euclideanDir, "\Euclidean", num2str(i),".csv");
    wassPath = strcat(wassDir, "\Wasserstein", num2str(i), ".csv");
    label = strcat(labelDir, "\labels", num2str(i), ".csv");

    euc = readmatrix(eucPath);
    wass = readmatrix(wassPath);
    label = readmatrix(label);

    sinus = find(label==0);
    jet = find(label==1);

    [mds1, ~] = cmdscale(euc, 3);
    [mds2, ~] = cmdscale(wass, 3);
    
    if k ==1

        figure;
    end

   
   
    subplot(5,4, k);
    scatter3(mds1(sinus,1), mds1(sinus,2), mds1(sinus,3), "filled", "DisplayName", 'b');
    hold on
    scatter3(mds1(jet,1), mds1(jet,2), mds1(jet,3), "filled", "DisplayName", 'r');
    hold off
    title("Euclidean MDS Patient = "+num2str(j));
    
    subplot(5,4,k+1);
    scatter3(mds2(sinus,1), mds2(sinus,2), mds2(sinus,3), "filled", "DisplayName", 'b');
    hold on
    scatter3(mds2(jet,1), mds2(jet,2), mds2(jet,3), "filled", "DisplayName", 'r');
    hold off
    title("Wasserstein MDS Patient = "+num2str(j));
    k = k+2;
    j = j+1;
end

int2 = [15,12,6,3];
k = 1;
% Compute Kmeans from MDS embedding.
for i=int2
    label = strcat(labelDir, "\labels", num2str(i), ".csv");
    wassPath = strcat(wassDir, "\Wasserstein", num2str(i), ".csv");
    wass = readmatrix(wassPath);
    label = readmatrix(label);

    sinus = find(label==0);
    jet = find(label==1);

    [mds2, ~] = cmdscale(wass, 3);

    idx = kmeans(mds2, 4);
    classBelonging = zeros(4, height(mds2)-10);

    for j=1:height(mds2)-10

        class1 = find(idx(j:j+9) == 1);
        class2 = find(idx(j:j+9) == 2);
        class3 = find(idx(j:j+9) == 3);
        class4 = find(idx(j:j+9) == 4);

        classBelonging(1,j) = height(class1)/10;
        classBelonging(2,j) = height(class2)/10;
        classBelonging(3,j) = height(class3)/10;
        classBelonging(4,j) = height(class4)/10;

    end
    if k == 1
        figure;
    end
    subplot(2,2,k)
    x = 1:height(mds2)-10;
    plot(x, smooth( classBelonging(1,:), 50), "DisplayName", "Cluster 1");
    hold on
    plot(x, smooth( classBelonging(2,:), 50), "DisplayName", "Cluster 2");
    hold on
    plot(x, smooth(classBelonging(3,:), 50), "DisplayName", "Cluster 3");
    hold on
    plot(x, smooth(classBelonging(4,:),50), "DisplayName", "Cluster 4");
    hold on
    plot(x, label(1:height(mds2)-10), "LineWidth",2, "DisplayName", "JET Beats");
    hold off
    k = k+1;





end
suptitle("Class membership percentage based on Kmeans algorithm.");
