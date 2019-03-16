function Main_RunGridworld()
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

% run maze experiments
% you need to expand this script to run the assignment

close all
clear all
clc

% YOU NEED TO DEFINE THESE VALUES
limits = [-0.77 -0.3; -0.3 0.27;];

% build the maze
maze = CMazeMaze10x10(limits);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOU NEED TO DEFINE THESE VALUES
% init the q-table
minVal = 0.01;
maxVal = 0.1;
maze = maze.InitQTable(minVal, maxVal);

% test values
state = 1;
action = 4;

% draw the maze
%maze.DrawMaze();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this will be used by Q-learning as follows:
q = maze.QValues(state, action);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOU NEED TO FINISH OFF THIS FUNCTION
% get the reward from the action on the surrent state
% this will be used by Q-learning as follows:
reward = maze.RewardFunction(state,action);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOU NEED TO FINISH OFF THIS FUNCTION
% build the transition matrix
maze = maze.BuildTransitionMatrix();
% print out values

% get the next state due to that action
% this will be used by Q-learning as follows:
% resultingState = maze.tm(state, action);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOU NEED TO FINISH OFF THIS FUNCTION
% test random start
startingState = maze.RandomStatingState();
    %Set trials
    trials = 100;
    %Set episodes
    episodes = 1000;
    % Set Discount rate
    gamma = 0.9;
    % Set Learning rate
    alpha=0.2;
    %Explore possibility
    explore = 0.1;
    %Run Q-Learning Algorithm
    [steps, qval] = maze.Trials(trials,episodes,alpha,gamma,explore);
maze.QValues = qval;
plot(steps);
solution = maze.SolveMaze(maze.QValues)
maze.DrawMazeSolution(solution);
maze.plotSteps(steps);
path = maze.getPathXY(solution);

[P1,P2] = MoveArmEndPoint(path);

maze.DrawMazeWithArm(solution,P1,P2);

end
