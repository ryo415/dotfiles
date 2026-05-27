#!/bin/bash

cliphist list | walker --dmenu | cliphist decode | wl-copy
