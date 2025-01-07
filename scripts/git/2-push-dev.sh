#!/bin/bash
git add .
git commit -m "$1"  # Pass the commit message as an argument
git push origin dev
