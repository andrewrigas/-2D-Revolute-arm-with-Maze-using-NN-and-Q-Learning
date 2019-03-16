%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% all rights reserved
% Author: Dr. Ian Howard
% Associate Professor (Senior Lecturer) in Computational Neuroscience
% Centre for Robotics and Neural Systems
% Plymouth University
% A324 Portland Square
% PL4 8AA
% Plymouth, Devon, UK
% howardlab.com
% 22/09/2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


classdef CMazeMaze10x10
    % define Maze work for RL
    % Detailed explanation goes here
    
    properties
        
        % parameters for the gmaze grid management
        %scalingXY;
        blockedLocations;
        cursorCentre;
        limitsXY;
        xStateCnt;
        yStateCnt;
        stateCnt;
        stateNumber;
        totalStateCnt
        squareSizeX;
        cursorSizeX;
        squareSizeY;
        cursorSizeY;
        stateOpen;
        stateStart;
        stateEnd;
        stateEndID;
        stateX;
        stateY;
        xS;
        yS
        stateLowerPoint;
        textLowerPoint;
        stateName;
        
        % parameters for Q learning
        QValues;
        tm;
        actionCnt;
    end
    
    methods
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % constructor to specity maze
        function f = CMazeMaze10x10(limitsXY)
            
            % set scaling for display
            f.limitsXY = limitsXY;
            f.blockedLocations = [];
            
            % setup actions
            f.actionCnt = 4;
            
            % build the maze
            f = SimpleMaze10x10(f);
            
            % display progress
            disp(sprintf('Building Maze CMazeMaze10x10'));
            
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % build the maze
        function f = SetMaze(f, xStateCnt, yStateCnt, blockedLocations, startLocation, endLocation)
            
            % set size
            f.xStateCnt=xStateCnt;
            f.yStateCnt=yStateCnt;
            f.stateCnt = xStateCnt*yStateCnt;
            
            % compute state countID
            for x =  1:xStateCnt
                for y =  1:yStateCnt
                    
                    % get the unique state identified index
                    ID = x + (y -1) * xStateCnt;
                    
                    % record it
                    f.stateNumber(x,y) = ID;
                    
                    % also record how x and y relate to the ID
                    f.stateX(ID) = x;
                    f.stateY(ID) = y;
                end
            end
            
            % calculate maximum number of states in maze
            % but not all will be occupied
            f.totalStateCnt = f.xStateCnt * f.yStateCnt;
            
            
            % get cell centres
            f.squareSizeX= 1 * (f.limitsXY(1,2) - f.limitsXY(1,1))/f.xStateCnt;
            f.cursorSizeX = 0.5 * (f.limitsXY(1,2) - f.limitsXY(1,1))/f.xStateCnt;
            f.squareSizeY= 1 * (f.limitsXY(2,2) - f.limitsXY(2,1))/f.yStateCnt;
            f.cursorSizeY = 0.5 * (f.limitsXY(2,2) - f.limitsXY(2,1))/f.yStateCnt;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % init maze with no closed cell
            f.stateOpen = ones(xStateCnt, yStateCnt);
            f.stateStart = startLocation;
            f.stateEnd = endLocation;
            f.stateEndID = f.stateNumber(f.stateEnd(1),f.stateEnd(2));
            
            % put in blocked locations
            for idx = 1:size(blockedLocations,1)
                bx = blockedLocations(idx,1);
                by = blockedLocations(idx,2);
                f.stateOpen(bx, by) = 0;
            end
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % get locations for all states
            for x=1:xStateCnt
                for y=1:xStateCnt
                    
                    % start at (0,0)
                    xV = x-1;
                    yV = y-1;
                    
                    % pure scaling component
                    % assumes input is between 0 - 1
                    scaleX =  (f.limitsXY(1,2) - f.limitsXY(1,1)) / xStateCnt;
                    scaleY = (f.limitsXY(2,2) - f.limitsXY(2,1)) / yStateCnt;
                    
                    % remap the coordinates and add on the specified orgin
                    f.xS(x) = xV  * scaleX + f.limitsXY(1,1);
                    f.yS(y) = yV  * scaleY + f.limitsXY(2,1);
                    
                    % remap the coordinates, add on the specified orgin and add on half cursor size
                    f.cursorCentre(x,y,1) = xV * scaleX + f.limitsXY(1,1) + f.cursorSizeX/2;
                    f.cursorCentre(x,y,2) = yV * scaleY + f.limitsXY(2,1) + f.cursorSizeY/2;
                    
                    f.stateLowerPoint(x,y,1) = xV * scaleX + f.limitsXY(1,1);  - f.squareSizeX/2;
                    f.stateLowerPoint(x,y,2) = yV * scaleY + f.limitsXY(2,1); - f.squareSizeY/2;
                    
                    f.textLowerPoint(x,y,1) = xV * scaleX + f.limitsXY(1,1)+ 10 * f.cursorSizeX/20;
                    f.textLowerPoint(x,y,2) = yV * scaleY + f.limitsXY(2,1) + 10 * f.cursorSizeY/20;
                end
            end
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % draw rectangle
        function DrawSquare( f, pos, faceColour)
            % Draw rectagle
            rectangle('Position', pos,'FaceColor', faceColour,'EdgeColor','k', 'LineWidth', 3);
        end
        
        % draw circle
        function DrawCircle( f, pos, faceColour)
            % Draw rectagle
            rectangle('Position', pos,'FaceColor', faceColour,'Curvature', [1 1],'EdgeColor','k', 'LineWidth', 3);
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % draw the maze
        function DrawMaze(f)
            figure('position', [100, 100, 1200, 1500]);
            fontSize = 20;
            hold on
            h=title(sprintf('ISH: Maze wth %d x-axis X %d y-axis cells', f.xStateCnt, f.yStateCnt));
            set(h,'FontSize', fontSize);
            
            for x=1:f.xStateCnt
                for y=1:f.yStateCnt
                    pos = [f.stateLowerPoint(x,y,1)  f.stateLowerPoint(x,y,2)  f.squareSizeX f.squareSizeY];
                    
                    % if location open plot as blue
                    if(f.stateOpen(x,y))
                        DrawSquare( f, pos, 'b');
                        % otherwise plot as black
                    else
                        DrawSquare( f, pos, 'k');
                    end
                end
            end
            
            % put in start locations
            for idx = 1:size(f.stateStart,1)
                % plot start
                x = f.stateStart(idx, 1);
                y = f.stateStart(idx, 2);
                pos = [f.stateLowerPoint(x,y,1)  f.stateLowerPoint(x,y,2)  f.squareSizeX f.squareSizeY];
                DrawSquare(f, pos,'g');
            end
            
            % put in end locations
            for idx = 1:size(f.stateEnd,1)
                % plot end
                x = f.stateEnd(idx, 1);
                y = f.stateEnd(idx, 2);
                pos = [f.stateLowerPoint(x,y,1)  f.stateLowerPoint(x,y,2)  f.squareSizeX f.squareSizeY];
                DrawSquare(f, pos,'r');
            end
            
            % put on names
            for x=1:f.xStateCnt
                for y=1:f.yStateCnt
                    sidx=f.stateNumber(x,y);
                    stateNameID = sprintf('%s', f.stateName{sidx});
                    text(f.textLowerPoint(x,y,1),f.textLowerPoint(x,y,2), stateNameID, 'FontSize', 20)
                end
            end
        end
        
        
        function DrawMazeSolution(f,solution)
            solutionXY = f.getPathXY(solution);
            %DrawMaze(f);
            hold on 
            h = plot(solutionXY(:,1),solutionXY(:,2),'mx');
            set(h, 'MarkerSize', 18);
            set(h, 'LineWidth', 5);
            h = plot(solutionXY(:,1),solutionXY(:,2),'m-', 'LineWidth', 4);
           
        end
        
        function DrawMazeWithArm(f,solution,P1,P2,origin)
            f.DrawMaze();
            f.DrawMazeSolution(solution);
            hold on
            h = title('ISH: Animation of Revolute Arm moving Along path in Maze')
            set(h, 'FontSize', 18);
            h = xlabel('Horizontal position[m]')
            set(h, 'FontSize', 15);
            h = ylabel('Vertical position [m]')
            set(h, 'FontSize', 15);
            h = plot(origin(1),origin(2),'k*');
            set(h, 'MarkerSize', 14);
            set(h, 'LineWidth', 2);

            for i = 1: samples
                h = plot([origin(1),P1(i,1)],[origin(2),P1(i,2)],'b-');
                set(h, 'LineWidth', 2);
                pause(0.5);
                h = plot(P1(i,1),P1(i,2),'go');
                set(h, 'MarkerSize', 5);
                set(h, 'LineWidth', 3);
                pause(0.5);
                h = plot(P2(i,1),P2(i,2),'ro');
                set(h, 'MarkerSize', 5);
                set(h, 'LineWidth', 3);
                pause(0.5)
                h = plot([P1(i,1),P2(i,1)],[P1(i,2),P2(i,2)],'b-');
                set(h, 'LineWidth', 2);
                legend('Origin');
                pause(1);
            end
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % setup 10x10 maze
        function f = SimpleMaze10x10(f)
            
            xCnt=10;
            yCnt=10;
            
            % specify start location in (x,y) coordinates
            % example only
            startLocation= [1 1];
            % YOUR CODE GOES HERE
            
            
            % specify end location in (x,y) coordinates
            % example only
            endLocation=[10 10];
            % YOUR CODE GOES HERE
            
            
            % specify blocked location in (x,y) coordinates
            % example only
            blockedLocations = [1 5; 1 9; 2 2; 2 3; 3 3; 3 4;
                3 5; 3 9; 4 1; 4 4; 4 9; 5 5; 5 7; 5 9; 6 3; 6 5; 6 7; 6 9;
                8 3; 8 6; 8 7; 8 9; 9 3; 9 7; 10 7;];
            % YOUR CODE GOES HERE
            
            % build the maze
            f = SetMaze(f, xCnt, yCnt, blockedLocations, startLocation, endLocation);
            
            % write the maze state
            maxCnt = xCnt * yCnt;
            for idx = 1:maxCnt
                f.stateName{idx} = num2str(idx);
            end
            
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % reward function that takes a stateID and an action
        function reward = RewardFunction(f, stateID, action)
            
            % init to no reqard
            reward = 0;
            %Getting the x and y values of action from the current stateID
            [x,y] = f.move(stateID,action);  
            
            valid = f.validAction(x,y);
            
            if(valid == 2) 
                % Invalid Actions
                reward = -inf;
            elseif(valid == 1) 
                % Actions that move the agent to blockLocation
                reward = -10;
            else
                %Set the move to nextState and check Rewards
                nextStateID = f.stateNumber(x,y);
                reward = nextStateReward(nextStateID);
            end
            
            function reward = nextStateReward(nextStateID)
                if(f.IsEndState(nextStateID) == 1)
                    %Goal reward 
                    reward = 10;
                else 
                    %Step reward
                    reward = 0;
                end     
            end
            return 
        end
        
        function [x, y] = move(f,stateID,action)
            % A function that move Agent to the maze
            x = f.stateX(stateID);
            y = f.stateY(stateID);
            % 1 = up 2 = right 3 = down 4=left
            if(action == 1) 
                y = y + 1;
            elseif(action == 2)
                x = x + 1;
            elseif(action == 3)
                y = y - 1;
            elseif (action == 4)
                x = x -1 ;
            else
                return
            end
        end
        
        function valid = validAction(f,x,y)
            % Check if action is valid
            % Not moving to blockloaction Or out of bounds
            % Return 0 if is valid
            % 1 if is blockedLocation
            % 2 if is out Of bounds
            
            valid = 0;
            
            if(x <= 0 || y<=0 || f.xStateCnt < x || f.yStateCnt < y)
                valid = 2;
            elseif(f.stateOpen(x,y) == 0)
                valid = 1;
            end
            return
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % function  computes a random starting state
        function startingState = RandomStatingState(f)
            startingState = [];
            for i = 1 : 1000
                b=0;
                while(b == 0)
                    %Get random state
                    state = randi([1 f.stateCnt],1);
                    %Check if is open and not the Goal State
                    if(f.stateOpen(f.stateX(state),f.stateY(state)) ~= 0 && f.stateEndID ~= state)
                        b = 1;
                        %Save it
                        startingState = [startingState state];
                    end
                end
            end
            return
        end
        
        function histogramStartingStates(f,bins)
            figure
            hold on
            histogram(f.RandomStatingState(),bins);
            h = title('ISH: Histogram Test of starting states')
            set(h, 'FontSize', 18);
            h = xlabel('Data point Value')
            set(h, 'FontSize', 15);
            h = ylabel('Data point occurrences')
            set(h, 'FontSize', 15);
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % look for end state
        function endState = IsEndState(f, state)            
            % default to not found
            endState=0;
            %Check if ID of state is equald with the Goal State
            if(f.stateEndID == state)
                endState = 1;
            end
            
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % init the q-table
        function f = InitQTable(f, minVal, maxVal)
            
            mazeSize = f.xStateCnt * f.yStateCnt;
            % allocate
            f.QValues = zeros(mazeSize, f.actionCnt);
            %Initialias Qvalues randomly from Min to Max Val
            f.QValues = minVal + (maxVal - minVal)*rand(mazeSize,f.actionCnt);
            
        end
        
        function surfQTable(f)
            x = 1:f.actionCnt;
            y = 1:mazeSize;
            
            [X,Y] = meshgrid(x,y);
            
            figure
            surf(X,Y,f.QValues);
            title('Q-function table values');
            xlabel('States');
            ylabel('Actions');
            zlabel('Q-Values');
            zlim([0.01 1]);
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % % build the transition matrix
        % look for boundaries on the grid
        % also look for blocked state
        function f = BuildTransitionMatrix(f)
            
            % allocate
            f.tm = zeros(f.xStateCnt * f.yStateCnt, f.actionCnt);
            %Get
            for i = 1 : f.xStateCnt
                for j = 1 : f.yStateCnt
                    for a = 1 : f.actionCnt
                       %Calculate state
                       state =  i + (j -1) * f.xStateCnt;
                       %Make all possible actions
                       [x, y] = f.move(state,a);
                       %Check if move is valid
                        if( f.validAction(x,y) < 2)
                            %Update TransitionMatrix
                            f.tm(state,a) = f.stateNumber(x,y);
                        end
                    end
                end
            end  
        end
        
        
        function a = E_greedy(f,state,explore,QValues)
            %Find Possible actions
            [r, actions] = find(f.tm(state,:)>0);
            %Explore and Exploit
            if(rand(1) < explore)
                %Get Random action Explore
                a = actions(1,randi([1 length(actions)],1));
            else
                %Get max Qvalue Action Exploit
                [r,c] = max(QValues(state,actions));
                a = actions(c);  
            end
        end
        
        function QValues = UpdateQValue(f,state,action,max_q,alpha,gamma,QValues)
            q = QValues(state,action);
            %Q-learing Algorithm
            new_q = q + alpha * (f.RewardFunction(state,action) + gamma * max_q - q);
            %Set the new Q-value to our table
            QValues(state,action) = new_q;
        end
        
        function [steps, QValues] = Episodes(f,episodes,alpha,gamma,explore,QValues)
            %Allocate
            steps = [];
            %Get 1000 Random Starting States
            randomStartinStates = f.RandomStatingState();
            
            for i = 1:episodes
                state = randomStartinStates(i); %Get Random start Location
                step = 0; % Set to 0
                while(f.IsEndState(state) == 0)
                    %Get action by E-greedy function
                    action = f.E_greedy(state,explore,QValues); 
                    %Apply it to current state and get the next State
                    nextState = f.tm(state,action);
                    %Find Next State Possible actions
                    [r, n_actions] = find(f.tm(nextState,:)>0); 
                    %Find the next MAX q value of the nextState
                    max_q = max(QValues(nextState,n_actions));
                    %Update Qvalues
                    QValues = f.UpdateQValue(state,action,max_q,alpha,gamma,QValues);
                    %Set the current state equals to the next State
                    state = nextState;
                    
                    step = step + 1; %Count Steps             
                end
                steps = [steps step]; %Save them
            end
        end

        
        function [steps QValues] = Trials(f,trials,episodes,alpha,gamma,explore)
            %Getting Current Qvalues
            QValues = f.QValues;
            %Allocate steps
            steps = [];
            for t = 1:trials
                %Run Episodes and get steps and new Qvalyues
                [step QValues] = f.Episodes(episodes,alpha,gamma,explore,QValues);
                %Save all steps from all episodes
                steps = [steps; step];
            end
        end
            
        function stateSolution = SolveMaze(f,QValues) 
             %Set state to begin
             state = 1;
             %Initialiaze Solution
             stateSolution = state;
             %Set Explore rate 0
             explore = 0;
             
            for i = 1: f.xStateCnt * f.yStateCnt   
               %Get action using E-greedy function
               action = E_greedy(f,state,explore,QValues);
               %Get the next State
               state = f.tm(state,action);
               %Save all states
               stateSolution = [stateSolution state];
               %Break if we arrived to goal state
               if(f.IsEndState(state) == 1)
                   break;
               end
           end
        end
         
        function solutionXY = getPathXY(f,solution)
            solutionXY = [];
            for i = 1:length(solution) 
                x = f.stateX(solution(i));
                y = f.stateY(solution(i));
                solutionXY = [solutionXY; (f.cursorCentre(x,y,1) + 0.01) (f.cursorCentre(x,y,2) + 0.015)];
            end
                
        end
        
         function plotSteps(f,steps)
            figure
            hold on 
            plot(steps);
            h = title('ISH: Q-Learing in operation across multiple trials')
            set(h, 'FontSize', 18);
            h = xlabel('Number of steps')
            set(h, 'FontSize', 15);
            h = ylabel('Episodes')
            set(h, 'FontSize', 15);
         end
        
    end
end

