#-*-coding:utf8-*-
#!/usr/bin/env python


# Ce programme doit s'actionner dans deux conditions : quelqu'un dit "salut !" ou une autre phrase du genre, (utilisée pour saluer les gens présents sur le canal), ou lorsque quelqu'un quitte le canal.
# Cas du salut à deux arguments :
    # le second argument est la chaine "salut", et le premier le nom de la personne ayant salué
    # teuse saluera la personne si elle n'est pas dans sa bdd "salutationsNoms.Alk", et y enregistrera son nom 

# Cas de la déconnexion :
    # un seul argument : le nom du déconnecté. Il sera supprimé dans la bdd



# IMPORTS
import sys, os
from random import choice # on importe le choix de valeur dans une liste

try:
    import cPickle as pickle # on essaye d'importer le module cPickle, plus rapide, sous le nom de pickle
except:
    import pickle # si ça foire, on utile pickle normal





# LISTE DES SALUTATIONS
liste_Salut = [
    "Salut",
    "Hey",
    "Oy",
    "Salutations",
    "Holà"
]


# LISTE DES AU REVOIRS
liste_AuRevoir = [
    "Salut"
    "Au revoir"
    "A plus tard"
    "A++"
]





def dejaSalue():
    """Renvois 1 si l'utilisateur de nom sys.argv[1] est déjà présent dans le fichier de rencencement, 0 sinon"""
    # on recherche le nom dans le fichier. Si on le trouve, on renvois 1
    if os.path.isfile('salutationsNoms.Alk') :
        doc = open('salutationsNoms.Alk', 'rb')
        liste = pickle.load(doc)
        pos = liste.index(sys.argv[1])
        if pos != -1 :  #on a trouvé le nom, il a donc déjà été salué !
            return 1
        return 0        # On n'a pas trouvé le nom...




# GESTION DE LA REPONSE AU SALUT
def reponseSalut():
    """Réponse selon le salut envoyé par l'utilisateur, si il n'a pas encore salué"""
    if not dejaSalue() : # S'il n'a pas encore salué
        nom = sys.argv[1]
        salut = choice(liste_Salut)
        print("{0}, {1} !".format(salut, nom))
        # on créé la liste
        liste = []

        # si le fichier de recencement existe
        if os.path.isfile('salutationsNoms.Alk'):
            # on charge le nom de la personne dans la liste du fichier
            doc = open('salutationsNoms.Alk', 'rb')
            liste = pickle.load(doc)
            # des fois que le fichier soit vide...
            if liste == 0 :
                liste = [] 
            doc.close()

        # on ajoute le nom à la liste
        liste.append(nom)
        # et on met cette liste dans le fichier, en écrasant la liste précédente
        doc = open('salutationsNoms.Alk', 'wb')
        pickle.dump(liste, doc)
        doc.close()
        





# GESTION DU DEPART D'UN UTILISATEUR
def departUtilisateur():
    nom = sys.argv[1]
    if os.path.isfile('salutationsNoms.Alk') :
        doc = open('salutationsNoms.Alk', 'rb')
        liste = pickle.load(doc)
        # on modifie la liste pour supprimer, s'il existe le nom de la personne partie
        if liste.index(sys.argv[1]) >= 0 :
            liste.remove(sys.argv[1])
        #On ferme le fichier et on le réouvre en écriture. On y charge la liste modifiée en écrasant la liste précédente
        doc.close()
        doc = open('salutationsNoms.Alk', 'wb')
        pickle.dump(liste, doc)
        doc.close()
        print('{0}, {1}'.format(choice(liste_AuRevoir), sys.argv[1]))






def main():
    # récupération du nombre d'argument réels
    nbArg = len(sys.argv)-1
    # en fonction du nombre d'argument, on lance les fonctions
    if nbArg == 1 : # un argument : quelqu'un part
        departUtilisateur()
    elif nbArg == 2 :
        reponseSalut()



if __name__ == '__main__' :
    main()






