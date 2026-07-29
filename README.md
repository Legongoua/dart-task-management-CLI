# 📝 Task CLI (Dart)

Un petit gestionnaire de tâches en ligne de commande codé en Dart pur.

Ce projet a été réalisé pour mettre en pratique la programmation orientée objet (POO), la gestion de fichiers JSON, les génériques et les tests unitaires.

---

## ⚡ Fonctionnalités

- ➕ **Ajouter une tâche** (classique ou urgente avec date limite)
- 🏷️ **Gérer les priorités** (Basse, Moyenne, Haute)
- 📋 **Lister et trier** les tâches automatiquement par priorité
- ✅ **Marquer comme terminée** ou 🗑️ **Supprimer** une tâche
- 💾 **Sauvegarde automatique** dans un fichier local `tasks.json`

---

## 🚀 Comment lancer le projet

### Prérequis
Avoir [Dart](https://dart.dev/get-dart) installé sur sa machine.

### 1. Cloner le projet
```bash
git clone <URL_DE_TON_REPO_GITHUB>
cd task_cli
dart pub get
dart run bin/main.dart
