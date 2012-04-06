#!/usr/bin/env python
#-*-encoding:utf8-*-

# Bullshit software
# Mathieu (matael) Gaborit
#
# feb. 2012
#
# Choose a drink

from random import choice

LIST_B = [
    "un café",
    "de l'eau",
    "un thé vert",
    "un thé vanille",
    "un thé menthe",
    "un thé noir",
    "un diabolo grenadine",
    "un malibu",
    "un cidre",
    "un whisky",
    "un label 5 (aka. huile de moteur...)",
    "un citron à eau",
    "une menthe à l'eau",
    "une bière",
    "une flaque d'eau sur le trottoir d'en face",
    "un rhum"]

LIST_P = [
    "Enfile toi",
    "Va boire",
    "Pourquoi t'essaierai pas",
    "Va laper"]


def main():
    print("{0} {1}!".format(choice(LIST_P), choice(LIST_B)))

if __name__=='__main__': main()
