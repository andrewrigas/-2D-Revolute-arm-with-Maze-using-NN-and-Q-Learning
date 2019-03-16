
function [W1 , W2 , error] = trainNeuralNetwork(data,target,hiddenUnits)
            
    [W1,W2 ,error] = train(data,target,hiddenUnits);
    return;
 
    function [W1,W2 ,error] = train(data,target,hiddenUnits)
        % Train our weights
        % Add bias row to all data
        dataWithBias = addBiasToMatrix(data);

        
        % Get some random Weights for input to hidden layer
        W1 = getRandomWeights(hiddenUnits,size(dataWithBias,1));
        
        % Get some random Weights + 1 adding Bias weight 
        W2 =  getRandomWeights(size(target,1),hiddenUnits+1);
        
        %Empry error set
        error = [];
        
        %Loop iterations
        iterations = 2000;
        
        % Learning rate
        alpha = 0.001;
  
        % Train Neural Network
        for i = 1:iterations
            
            % Get results of the hidden and outpur layers (Forward propagation)
            [o , a] = getPrediction(dataWithBias,W1,W2);
            
            %Overrall Cost function
            e = sum(cost(target,o));
            %Store it
            error = [error; e];
            
            % Remove bias weights
            W2hat = W2(:,1:end-1);
            
            %Remove bias from Hidden Layer
            aHat = a(1:end-1,:);
            
            %Part of derivative for W2 and W1
            d3 = (o - target);
            
            %Part of derivative for W1
            d2 = W2hat' * d3 .* aHat .* (1 - aHat);
            
            %The actuall Drivative of W1 and W2
            dW1 = d2 * dataWithBias';
            dW2 = d3 * a';
            
            %Update Weights
            W2 = W2 - (alpha * dW2);
            W1 = W1 - (alpha * dW1);
        end
        
        return
    end
        
    
     function W = getRandomWeights(x,y)
        % W is an x*y matrix with random Values to train for our NN
        W = randn(x,y)
        return
     end
    

      function E = cost(target,prediction) 
         %Calculate the error
         E = 0.5 .* (prediction - target).^2;
         return
      end
 end
    
 