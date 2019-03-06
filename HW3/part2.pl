% Example calls

%route(edirne, Y, C).
%route(kars, Y, C).
%route(edirne, izmir, 8).


% knowledge base - Facts

%I didnt explained all the facts. They all easy to understand

flight(edirne, erzurum, 5).  %Edirne and erzurum has a flight with cost 5
flight(erzurum, edirne, 5).  %Erzurum and edirne has a flight with cost 5
flight(erzurum, antalya, 2).  %Erzurum and antalya has a flight with cost 5
flight(antalya, erzurum, 2).
flight(antalya, izmir, 1).
flight(izmir, antalya, 1).
flight(antalya, diyarbakýr, 5).
flight(diyarbakýr, antalya, 5).
flight(diyarbakýr, ankara, 8).
flight(ankara, diyarbakýr, 8).
flight(izmir, ankara, 6).
flight(ankara, izmir, 6).
flight(izmir, istanbul, 3).
flight(istanbul, izmir, 3).
flight(istanbul, ankara, 2).
flight(ankara, istanbul, 2).
flight(istanbul, trabzon, 3).
flight(trabzon, istanbul, 3).
flight(ankara, trabzon, 6).
flight(trabzon, ankara, 6).
flight(ankara, kars, 3).
flight(kars, ankara, 3).
flight(kars, gaziantep, 3).
flight(gaziantep, kars, 3).

% rules

route(X, Y, C) :- flight(X, Y, C).  %Checks there is a flight between X and Y with cost C
route(X, Y, C) :- helper(X, Y, C, []).	 % Call the helper function with empty list
helper(X, Y, C, _) :- flight(X, Y, C).  % Checks there is a flight between X and Y with C cost. V is unnecessary
helper(X, Y, C, V) :- 
	not(member(X, V)), % Checks the X city is visited or not 
	flight(X, Z, N),  %Checks there is a flight between X and other city (Except Y) with N cost
	helper(Z, Y, M, [X|V]),  %Mark the X city as visited and call the helper function 
	not(X=Y),   % Checks the X and Y cities are different or not
	C is N + M. % C = N+M for calculating the cost. N is the cost  from X to Z and M is the cost of recursive call.
