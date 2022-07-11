% s(casP) Programming
:- style_check(-discontiguous).
:- style_check(-singleton).

%fatos
%personagem(entidade)
personagem(mario).
personagem(peach).
personagem(cappy).
personagem(tiara).
personagem(topper).
personagem(madamebroodal).
personagem(knucklotec).
personagem(torkdrift).
personagem(rango).
personagem(bowser).
personagem(mechawiggler).
personagem(mollusquelanceur).
personagem(rango).
personagem(cookatiel).
personagem(ruineddragon).
personagem(robobrood).

%amigo - Omiti os que não vão aparecer mas estão no diagrama
%amigo(personagem).
amigo(peach).
amigo(cappy).
amigo(tiara).

%inimigo - Omiti os que não vão aparecer mas estão no diagrama
%inimigo(personagem).
inimigo(topper).
inimigo(madamebroodal).
inimigo(knucklotec).
inimigo(torkdrift).
inimigo(rango).
inimigo(bowser).
inimigo(mechawiggler).
inimigo(mollusquelanceur).
inimigo(rango).
inimigo(cookatiel).
inimigo(ruineddragon).
inimigo(robobrood).

%reinos
%reino(entidade).
reino(cap).
reino(cascade).
reino(sand).
reino(wooded).
reino(lake).
reino(cloud).
reino(lost).
reino(metro).
reino(seaside).
reino(snow).
reino(luncheon).
reino(ruined).
reino(bowser).
reino(moon).

%luas
%luas(reino, quant).
luas(cap, 0).
luas(cascade, 5).
luas(sand, 16).
luas(wooded, 16).
luas(lake, 8).
luas(cloud, 0).
luas(lost, 10).
luas(metro, 20).
luas(seaside, 10).
luas(snow, 10).
luas(luncheon, 18).
luas(ruined, 3).
luas(bowser, 8).
luas(moon, 0).

%enfrentar - Em reinos com mais de um adversário, eu selecionei o último que você encontra para ser o boss
%enfrentar(reino, inimigo).
enfrentar(cap, topper).
enfrentar(cascade, madamebroodal).
enfrentar(sand, knucklotec).
enfrentar(wooded, torkdrift).
enfrentar(lake, rango).
enfrentar(cloud, bowser).
enfrentar(metro, mechawiggler).
enfrentar(seaside, mollusquelanceur).
enfrentar(snow, rango).
enfrentar(luncheon, cookatiel).
enfrentar(ruined, ruineddragon).
enfrentar(bowser, robobrood).
enfrentar(moon, bowser).

%quantas luas cada tipo de inimigo vale
boss_vale(6).
inimigo_vale(3).

%hp base
vida_base(3).

%deseja - reinos em que bowser não passa com intuito de pegar algo foram omitidos
%deseja(reino, objetivo).
deseja(cap, tiara).
deseja(sand, aliancas).
deseja(wooded, flores).
deseja(lake, vestidonoiva).
deseja(metro, combustivel).
deseja(luncheon, comida).
deseja(moon, capela).
casas(5, 3).


%regras

%determina a quantidade de luas em um reino dado
quant_luas(REINO, LUAS) :- luas(REINO, LUAS).

%determina a quantidade de casas a partir de um reino
quant_casas(REINO, LUAS, CASAS) :- luas(REINO,LUAS), CASAS is LUAS*2+1.
%quant_casas(CAP, LUAS, CASAS). - SINTAXE DA FUNCAO

%determina o boss a ser enfrentado em dado reino
qual_adv(REINO, INIMIGO) :- enfrentar(REINO, INIMIGO).
%qual_adv(cascade, X).

%criar lista com n casas
criar_lista(CASAS, LISTA):- 
  findall(Num, between(1, CASAS, Num), LISTA).

tem_boss(REINO, B) :-
    enfrentar(REINO, X) ->  
    	B is 1;
    	B is 0.

quant_inim(LUAS, BOSS, QINI) :-
    (BOSS =:= 1, LUAS >= 3) ->%tem boss e deve ter inimigo
    	(
        	LR is LUAS - 3,
            X is LR/2,
            QINI is ceil(X)
        );
    (BOSS =:= 1, LUAS < 4)->(%deve ter apenas o boss
		QINI is 0
	);
    (BOSS =:= 0)->%não tem boss
      (
      	X is LUAS/2,
      	QINI is ceil(X)
      ).

posicionar_inimigos(LISTA,QTDINI,CASAS) :-
    X is CASAS-1,
    length(LISTA,QTDINI),
	maplist(random(1,X),LISTAR),
    sort(LISTAR, LISTA).

gerar_lista(REINO, LUAS, CASAS, LISTA, LINI, QINI) :- 
    quant_luas(REINO, LUAS),
    quant_casas(REINO, LUAS, CASAS),
	
    tem_boss(REINO, B), %write(B),

    %QINI = ((LUAS - (6 * enfrentar(REINO, X) )) / 3) + 1,
    quant_luas(REINO, LUAS), quant_inim(LUAS, B, QINI),
    write('quant inim: '),writeln(QINI),
    
    criar_lista(CASAS, LISTA), %lista inicial
    posicionar_inimigos(LINI, QINI, CASAS).


casa_vazia() :- 
    writeln('Tudo parece seguro, avançando para a próxima casa!').
	%pensei em colocar um timer pra prosseguir, 1s talvez, para não ficar tudo muito rapido

batalha(HP, HPINI, LUAS) :-
    ((HPINI=:=0) -> %SE GANHAR, "retorna" true
    	LUAS = 3;
    (HP=:=0) ->  %SE MORRER, "retorna" false
    	fail;
    write('VIDA ATUAL: '), writeln(HP),
    write('VIDA INIMIGO: '), writeln(HPINI),
	turno(HP, HPF, HPINI, HPINIF),
	%limpar a tela aq
    batalha(HPF, HPINIF, LUAS)).

turno(HP, NHP, HINI, HINIF) :- 
    %como so ha 1 possibilidade de ambos se atacarem, 
    %e ainda sim, a ordem de ataque é a mesma, adicionei
    %um if para ignorar a vez da maquina se tiver sido eliminada
    writeln('O que deseja fazer?'),
    writeln('[1] ATACAR'), writeln('[2] DESVIAR'),
    read(INPUT),
    ((INPUT=:=1) ->
    	writeln('SUA VEZ!'),
		atk_turno(HINI, HINIF),
    	((HINIF>0) -> 
        	writeln('VEZ DO OPONENTE!'), 
        	atk_turno(HP, NHP); 
        !
        );
    (INPUT=:=2) -> (
	%nesse caso aqui, como um só vai atacar, acho que 
	%não precisa da condicional de encerramento
		SORTE is random(2),
		(SORTE>0) -> 
                   writeln('VOCÊ DESVIOU, LEVANDO O INIMIGO A SE ACERTAR'), 
                   NHP is HP, HINIF is HINI-1;
		writeln('NÃO CONSEGUIU DESVIAR, FICANDO EXPOSTO E LEVANDO DANO!'),
		atk_turno(HP, NHP),
		HINIF is HINI
    );
    writeln('ENTRADA INVÁLIDA!'), NHP is HP, HINIF is HINI
    ).

atk_turno(HPINI, HPIF) :-
	HPIF is HPINI-1.
    

%função de referência
%dosomething([]).
%dosomething([H|T]) :- process(H), dosomething(T).
percorre([], LINI, CASAS, B, HP, REINO).
percorre([H|T], LINI, CASAS, B, HP, REINO) :- %tá percorrendo no mínimo 2x????
    luas(REINO, LUAS),
    write(H),
    ((nth0(_,LINI,H), CASAS>1) -> %tem inimigo
    	writeln('UM INIMIGO SURGE EM SEU CAMINHO!'), 
    	%preciso de analisar o resultado da batalha aqui
    	((batalha(HP, 3, 3)) ->
        	writeln('deu bom'); writeln('VOCÊ MORREU!'),fail
        );
    ((CASAS =:= H, B=:=1) -> %chegou na ultima casa e tem boss
    	enfrentar(REINO, X),
        write('VOCÊ ENFRENTA '), writeln(X),
        %preciso de analisar o resultado da batalha aqui
    	((batalha(HP, 3, 3)) ->
        	writeln('deu bom'); writeln('VOCÊ MORREU!'),fail
        )
    );
    casa_vazia()
    ),
    percorre(T, LINI, CASAS, B, HP, REINO).%o passin da recursão

%carregar a fase
carregar_fase(REINO, _LUAS, _CASAS, _LISTA, _LINI, _QINI) :-
    tem_boss(REINO, B),
    gerar_lista(REINO, LUAS, CASAS, LISTA, LINI, QINI),
    writeln(LINI), writeln(LISTA),
    
    HP is 3,
    ((percorre(LISTA, LINI, CASAS, B, HP, REINO)) ->
    	writeln('ganhou!');writeln('perdeu')
    ).
    

lista_reinos(R) :- findall(X, (reino(X)), R).

mostrar_reinos([], N).
mostrar_reinos([H|T], N) :-
  format('[~|~`0t~d~2+] ', N), X is N+1,
  mostrar_reinos(T, X).

teste(a) :-
    lista_reinos(R),
    mostrar_reinos(R, 1),
	writeln('ESCOLHA UM REINO: '),
    read(L),
    ((L>0,L<15)->  
    	N is L-1, nth0(N, R, X), carregar_fase(X,_,_,_,_,_);
    	writeln('OPÇÃO INVÁLIDA! SELECIONE NOVAMENTE'),
        teste(a)
    ).