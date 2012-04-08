
#Mon premier script python, pour teuse.

import pickle           # qui utilise pickle en plus !
import sys              # pour les arguments
import os               # pour la suppression de la mémoire de teuse !



def souvenir():
    "Ouvre le fichier Messages.Alk pour y stocker les arguments de la boite de commande"
    #Ouverture du fichier en écriture et en binaire, pour pouvoir exploiter pickle
    doc = open('./Messages.Alk', 'wb')
    pickle.dump(sys.argv, doc)          # chargement de la structure de données dans le fichier
    doc.close()
    print("Ok !")                       #teuse indique qu'elle a bien enregistré la demande




def rappel():
    "Ouvre le fichier Messages.Alk pour y trouver le message à retourner"
    # sécurité contre l'inexistence de fichier
    if(os.path.isfile('Messages.Alk')):
        #Ouverture du fichier en lecture et en binaire pour pouvoir exploiter pickle
        doc = open('Messages.Alk', 'rb')
        arg = pickle.load(doc)              # sauvegarde de la structure de données dans "arg"
        doc.close()
        print(arg[2] + ' a dit que ' + arg[3]) 
    else:
        print("Je ne me souviens de rien...")




def oublis():
    "Supprime le contenu du fichier Messages.alk, générant ainsi la perte de mémoire de teuse"
    #pour éviter les erreurs, on ouvre le fichier, on le ferme, et on l'efface.
    doc = open('Messages.Alk', 'w')
    doc.close()
    os.remove('Messages.Alk')
    print('Oublier quoi ? ;)')






# nombre d'arguments envoyés au programme
nbArg = len(sys.argv) - 1 # on rappelle que le premier item de la liste est le nom du programme, d'où le -1

# sécurité
if(nbArg == 3):
    # On teste les différentes valeurs attendues
    if(sys.argv[1] == 'souvenir'):
        souvenir()
    elif(sys.argv[1] == 'rappel'):
        rappel()
    elif(sys.argv[1] == 'oublis'):
        oublie()








