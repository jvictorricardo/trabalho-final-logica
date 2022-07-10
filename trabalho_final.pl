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
vida_base(100).
vida_bboss(300).

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
    (BOSS =:= 1, LUAS >= 3) ->
    	(
        	LR is LUAS - 3,
            X is LR/2,
            QINI is ceil(X)
        );
    (BOSS =:= 1, LUAS < 4)->(
		QINI is 0
	);
    (BOSS =:= 0)->
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
    
    %lista inicial
    criar_lista(CASAS, LISTA), 
    %write('casas: '),writeln(LISTA),
    posicionar_inimigos(LINI, QINI, CASAS).
    %, write('inimigos: '), write(LINI).
    
    %determinar se tem chefe só ao percorrer ingame(?)
	%posicionar_chefe(L, CASAS, LISTA, B).


casa_vazia() :- 
    writeln('Tudo parece seguro, avançando para a próxima casa!').
	

encontro_inimigo(HP, HPINIM) :- 
    writeln('Um inimigo se aproxima...'),
	%while(hp>0 ou hpinim>0)
    %o que deseja fazer...1)atacar 2)desviar
    
    fail.

%trabalhar melhor na exibicao de tudo
reparar_odyssey(REINO, LUAS) :-
    luas(REINO, OBJ),
    ((OBJ=<LUAS) ->
    	writeln("Você reparou a odyssey com sucesso!");
    	writeln("Infelizmente você está preso nesse reino!");
    	fail
    ).



batalha(HP, HPINI, LUAS) :-
    ((HPINI==0) -> %SE GANHAR
    	LUAS = 3
	;(HP==0) ->  %SE MORRER
    	writeln('você morreu!'),
    	LUAS = 0;
    write('VIDA ATUAL: '), writeln(HP),
    write('VIDA INIMIGO: '), writeln(HPINI),
	turno(HP, HPF, HPINI, HPINIF),
	tty_clear,%testando o comando de limpar a tela
    batalha(HPF, HPINIF, LUAS)
    ).

turno(HP, NHP, HINI, HINIF) :-
    writeln('O que deseja fazer?'),
    writeln('[1] ATACAR'), writeln('[2] DESVIAR'),
    read(INPUT),
    ((INPUT=:=1) ->
    	atk_turno(HINI, 0, HINIF),
        writeln('VEZ DO OPONENTE!'),
        atk_turno(HP, 1, NHP);
    (INPUT=:=2) -> (
		SORTE is random(20),
		(SORTE>=10) -> writeln('VOCÊ DESVIOU, LEVANDO O INIMIGO A SE ACERTAR'), NHP is HP, HINIF is HINI-10;
		writeln('NÃO CONSEGUIU DESVIAR, FICANDO EXPOSTO E LEVANDO MAIS DANO!'),
		atk_turno(HP, 0, NHP)
    );
    writeln('ENTRADA INVÁLIDA!'), NHP is HP, HINIF is HINI
    ).
    	

atk_turno(HPINI, MAQ, HPIF) :-
	CRIT is random(100),
	((CRIT>=90) -> 
      (
          C = 2,
          writeln('Acerto crítico!')
      );
          C=1
    ),
    	
	ATK is floor(((HPINI/3)*(C))/((1*MAQ)+1)),
	HPIF is HPINI-ATK.



%função de referência
%dosomething([]).
%dosomething([H|T]) :- process(H), dosomething(T).
percorre([], LINI, CASAS, B, HP, REINO).
percorre([H|T], LINI, CASAS, B, HP, REINO) :- %tá percorrendo no mínimo 2x????
    luas(REINO, LUAS), writeln(LINI),
    ((nth0(_,LINI,H)), CASAS>1 -> %finalmente entendi o if, que emoção
    	batalha(HP, 120, LUAS);
    	%atualizar o hp e quantidade de estrelas
    	%verificar se morreu
    	casa_vazia()
    ),
    %verificar se tem boss
    ( (CASAS =:= H), B=:=1 -> 
    	enfrentar(REINO, X),write('Você enfrenta '),writeln(X),
    	batalha(HP, 240, LUAS);
    	!
    ),
    %else vai ser um prossegue ae men
    percorre(T,LINI, CASAS, B, HP, REINO).
	%vai percorrer um vetor de 1 a n

%carregar a fase
carregar_fase(REINO, _LUAS, _CASAS, _LISTA, _LINI, _QINI) :-
    %A LISTA DE 
    gerar_lista(REINO, LUAS, CASAS, LISTA, LINI, QINI),writeln(LINI),
    tem_boss(REINO, B),writeln(LISTA),
    HP is 100,
    percorre(LISTA, LINI, CASAS, B, HP, REINO),
	%percorrer a lista, quando encontrar casa que coincida com inimigo,
	%chamar encontro_inimigo, casa_vazia
	%chamar tem_boss e boss se tiver
	%se passar do boss com vida, chamar reparar_odyssey
	reparar_odyssey(REINO, LUAS).
	%reparo sucedido ou mal sucedido manda mensagem de sucesso ou fracasso

escolher_fase() :-
    %gerar a lista de fases para escolher
    %carregar a fase
    %jogar
    fail.

%sisteminha de luta -> verificar os hp's
%consertar a odyssey
%tá todo cagado o combate, ao desviar simplesmente quebra tudo