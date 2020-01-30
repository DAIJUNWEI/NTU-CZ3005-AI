
:-dynamic(did/1).
:-dynamic(didNot/1).
:-dynamic(asked/1).


/* Get start with 'ask(0)',nl is for jump into next line */
ask(0):- print('Welcome home,sweetie,what did you do today?'),nl,question(['behave yourself']).




/* Check if is empty. If yes, end code. */
question([]) :- print('ok sweetheart,we are going to have dinner now, go wash your hands. :)').	

/* Ask question of different activities,  add activity to "did" or "didNot" */
question(L) :-
	 print("Did you "), member(X,L), print(X),print("at school"), print('? y/n/q: '), read(Answer), (Answer==q -> abort;Answer==y -> assert(did(X));assert(didNot(X))), checkAnswer(X).
/* after "question(L)",the reply of child is either y or n. check the answer,If yes, execute execute"reply_yes". If no execute "reply_no" */ 
checkAnswer(Y) :- 
	did(Y), reply_yes(Y); reply_no(0).

/*if the child reply yes , we need to ask follow question that is in the follow list L*/
/*L is related to activity Y*/ 
reply_yes(Y) :- first_follow_question(Y, L), queryFollowUp(L).


/* if the child replys no,we need to ask whether the child did other activities. Ask question based upon list L */ 
reply_no(0) :- random_activity(L), question(L). 

random_activity(L) :- findnsols(100,X,random(X),L).





/*when kids says yes, go into the list of activity Y.and ask question in it. */
first_follow_question(Y, L) :- findnsols(100, X, related(Y,X), L).

/* Finds list of follow up questions, L, related to the previous follow up question Y */
/* Ask follow up questin based upon list L */ 
askFollowUp(Y) :- optionsFollowUp(Y, L), queryFollowUp(L).
/* Find list of related follow up questions, L, based upon previous follow up question, Y, using relatedFollowUp*/
optionsFollowUp(Y, L) :- findnsols(100, X, relatedFollowUp(Y,X), L).


/* Finds all objects in list 'asked', convert the list to set*/ 
/* Remove objects in list asked from list\object L result is Remainging. Checks if Remaining is empty*/ 
queryFollowUp(L) :- 
	findnsols(100,X,asked(X),Asked), list_to_set(L,S), list_to_set(Asked,A), subtract(S,A,Remaining), check_rest(Remaining). 



/* If empty, no more follow up questions, ask about another activity */
check_rest([]) :- reply_no(0).
/* If not empty, ask follow up question and add question to 'asked'*/
check_rest(R) :- member(X,R),print(X), print('? y/n/q: '), read(Answer), (Answer==q -> abort;assert(asked(X))), askFollowUp(X).


/*when the kids says yes about "eat", it will randomly find follow question in the eat list. */ 
/*it means random_member X are related to the activity */
related(eat, X):- eat(L),random_member(X, L).
related(play, X):- play(L),random_member(X, L).
related(sing, X):- sing(L),random_member(X, L).
related('behave yourself', X):- behave(L),random_member(X, L).
related(learn, X):- learn(L),random_member(X, L).
related('make some new friends', X):- make(L),random_member(X, L).



/*  X and Y are all in the same list L ,so parents will ask the related question. */ 
relatedFollowUp(Y, X) :- 
	eat(L),member(X,L),member(Y,L);
	play(L),member(X,L),member(Y,L);
	sing(L),member(X,L),member(Y,L);
	behave(L),member(X,L),member(Y,L);
	learn(L),member(X,L),member(Y,L);
	make(L),member(X,L),member(Y,L).
	


/* subtract already asked question from list */
/* Returns random activity from Remaining objects i.e from list Remaining */
random(Y) :- activity(A), findnsols(100,X,did(X),DidList), findnsols(100,X,didNot(X),DidNotList), append(DidList,DidNotList,History), list_to_set(A,S), list_to_set(History,H), subtract(S,H,Remaining), random_member(Y, Remaining).


/* List of activities */ 
activity([eat, play, sing, 'behave yourself', learn, 'make some new friends']).
/* Lists of follow questions*/
eat(['did you try cake', 'did you have candy', 'did you try sandwich', 'did you eat pizza','did you try chinese food']).
play(['did you play slides', 'did you play sandbox', 'did you play toys', 'did you play trains']).
sing(['did you sing birthday song ' ,'did you sing the jingle bell', 'did you sing the abc-song']).
behave(['did you say thank you to your teacher', 'did you say please' , 'did you smile to your friends']).
learn(['did you learn math', 'did you leartn chinese', 'did you learn Art']).
make(['do you like him/her', 'did you play games together?']).

did(nothing).
didNot(nothing).
asked(nothing).