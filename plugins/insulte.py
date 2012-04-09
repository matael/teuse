#-*-coding:utf8-*-
#!/usr/bin/env python

import sys
from random import choice


# deux types d'insultes : exclamative (t'es nul) et interrogatives (tu savais que t'était nul ?)

#insulte de la forme : Interpellation, sortie de liste
# l'interpellation use du nom, lorsqu'il est donné en premier argument.



# Liste des insultes
liste_Insulte = [
    "t'es qu'une émission de carbone 14",
    "t'es tellement pas attractif que même tes électrons s'en vont",
    "t'es tellement moche que les photons que tu réfléchi diminuent leur durée de vie",
    "t'es tellement pas drôle que même l'hydrogène ne te donne pas une voie éguë",
    "t'es aussi prévisible qu'une équation linéaire du premier ordre",
    "t'es tellement pas sécurisant que t'as tes attributs en public",
    "t'es connecté en socket avec ton propre cerveau pour réfléchir, sauf que vous n'utilisez pas le même protocole",
    "t'es aussi intuitif que la syntaxe polonaise inversée",
    "t'es formaté en UTF-1"
    "t'es aussi décourageant qu'un segmentation fault",
    "t'es aussi chiant qu'un virus, sauf que lui il est codé en ASM"

    "t'as pas assez de neurones pour faire du multithread",
    "t'as redoublé ta crèche tellement t'es pas adapté à l'intelligence",
    "t'as été codé en brainfuck",
    "t'as breaké une boucle alors que t'étais même pas dedans. C'est con, c'était celle qui relançait les instructions d'intelligence",
    "t'as arrêté ton développement à la prophase",
    "t'as raté le carrefour phylogénique qui sépare le singe de l'homme",
    "t'as jamais réussi à indenter ton code en Python",
    "t'as programmé en procédural avec java",
    "t'as applaudit ACTA"

    "ton adressage mémoire s'arrête à 0xFF",
    "ton adresse atitrée, c'est NULL",
    "ton processeur a une datasheet de 2 lignes",
    "ton pc n'a jamais vu le terminal, ni même son émulateur",
    "ton pc tourne sous brainfuck OS",

    "ta méthode parler() n'a pas d'argument"
    "ta carte son ne sait faire que du bruit chiant"
]



# Liste des suffixes d'interpellation interrogatives
liste_suf_int = [
    "Tu savais ",
    "On t'as déjà dit ",
    "T'avais remarqué ",
    "Tu te rendais compte "
]

# Liste des suffixes d'interpellation exclamatives
liste_suf_exc = [
    "Tout le monde sait ",
    "Il est démontré ",
    "Tu devrais te rappeler ",
    "Oublis pas "
]

# Liste des choix de mode d'insulte
liste_choixMode = [
    "exclamatif",
    "interrogatif"
]



def main():
    # si il y a 2 arg() ou plus, on considère que le second argument est la personne à insulter. Sinon, c'est que l'insulte est neutre
    if len(sys.argv) >= 2 :
        nom = sys.argv[1] + ' : ' # on récupère le nom à insulter, qu'on modifie pour bien l'insérer dans la chaine finale
    else:
        nom = '' # personne à insulter :(

    #insertion de l'appel et choix du mode (la fin de chaîne dépend de ce choix)
    chaine = '{0}'.format(nom)
    if choice(liste_choixMode) == "exclamatif" :
        chaine += '{0}que '.format(choice(liste_suf_exc))
        fin = ' !'
    else: 
        chaine += '{0}que '.format(choice(liste_suf_int))
        fin = ' ?'

    # on détermine l'insulte utilisée
    chaine += '{0}'.format(choice(liste_Insulte))

    chaine += fin
    print(chaine)


# séparer le comportement du programme module/main
if __name__=='__main__':
    main()





