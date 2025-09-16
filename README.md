# About this repository

This repository provides a **Docker-based backend stack** for an IoT Monitoring System.
It includes preconfigured services like **EMQX** and **NGINX**, orchestrated with Docker to handle telemetry ingestion, API routing, and proxying.

## Repository structure

- **emqx/** – Configuration and setup for the EMQX MQTT broker.
- **nginx/** – NGINX settings for reverse proxying and traffic routing.
- **tig/** – TIG stack configuration, responsible for storing and visualizing.
