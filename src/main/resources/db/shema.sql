CREATE TABLE role (
                      id BIGINT AUTO_INCREMENT PRIMARY KEY,
                      nom VARCHAR(50) NOT NULL UNIQUE CHECK (nom IN ('ADMIN', 'MEDECIN', 'SECRETAIRE', 'PATIENT')),
                      description VARCHAR(255),
                      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Table des utilisateurs
CREATE TABLE users (
                       id BIGINT AUTO_INCREMENT PRIMARY KEY,
                       login VARCHAR(50) NOT NULL UNIQUE,
                       password_hash VARCHAR(255) NOT NULL, -- Jamais en clair
                       nom VARCHAR(100) NOT NULL,
                       prenom VARCHAR(100) NOT NULL,
                       email VARCHAR(100) UNIQUE NOT NULL,
                       telephone VARCHAR(20),
                       actif BOOLEAN DEFAULT TRUE,
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Table de jointure user_role
CREATE TABLE user_role (
                           user_id BIGINT NOT NULL,
                           role_id BIGINT NOT NULL,
                           PRIMARY KEY (user_id, role_id),
                           CONSTRAINT fk_user_role_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
                           CONSTRAINT fk_user_role_role FOREIGN KEY (role_id) REFERENCES role(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ==============================================================================
-- MODULE PATIENT & DOSSIER MÉDICAL
-- ==============================================================================

-- Table des patients (liée à 1 User pour le profil)
CREATE TABLE patient (
                         id BIGINT AUTO_INCREMENT PRIMARY KEY,
                         numero_dossier VARCHAR(20) NOT NULL UNIQUE,
                         user_id BIGINT UNIQUE, -- Lié au profil User du diagramme
                         nom VARCHAR(100) NOT NULL,
                         prenom VARCHAR(100) NOT NULL,
                         date_naissance DATE NOT NULL,
                         sexe VARCHAR(10) CHECK (sexe IN ('M', 'F', 'AUTRE')),
                         telephone VARCHAR(20),
                         email VARCHAR(100) UNIQUE,
                         adresse TEXT,
                         groupe_sanguin VARCHAR(10),
                         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                         CONSTRAINT fk_patient_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;
CREATE INDEX idx_patient_nom ON patient(nom);

-- Table des dossiers médicaux (1-1 avec Patient)
CREATE TABLE dossier_medical (
                                 id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                 patient_id BIGINT NOT NULL UNIQUE,
                                 notes_generales TEXT,
                                 allergies TEXT,
                                 antecedents_medicaux TEXT,
                                 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                 updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                 CONSTRAINT fk_dossier_patient FOREIGN KEY (patient_id) REFERENCES patient(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Table des antécédents
CREATE TABLE antecedent (
                            id BIGINT AUTO_INCREMENT PRIMARY KEY,
                            dossier_medical_id BIGINT NOT NULL,
                            type VARCHAR(50) NOT NULL,
                            description TEXT,
                            date_evenement DATE,
                            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                            CONSTRAINT fk_antecedent_dossier FOREIGN KEY (dossier_medical_id) REFERENCES dossier_medical(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Table des préinscriptions
CREATE TABLE preinscription (
                                id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                nom VARCHAR(100) NOT NULL,
                                prenom VARCHAR(100) NOT NULL,
                                telephone VARCHAR(20),
                                email VARCHAR(100),
                                motif TEXT,
                                statut VARCHAR(20) DEFAULT 'NOUVELLE' CHECK (statut IN ('NOUVELLE', 'TRAITEE', 'REJETEE')),
                                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ==============================================================================
-- MODULE AGENDA / RENDEZ-VOUS
-- ==============================================================================

-- Table des rendez-vous
CREATE TABLE rdv (
                     id BIGINT AUTO_INCREMENT PRIMARY KEY,
                     patient_id BIGINT NOT NULL,
                     medecin_id BIGINT NOT NULL, -- Lié à User (MEDECIN)
                     date_rdv DATE NOT NULL,
                     heure_debut TIME NOT NULL,
                     heure_fin TIME NOT NULL,
                     motif VARCHAR(255),
                     statut VARCHAR(20) DEFAULT 'EN_ATTENTE' CHECK (statut IN ('EN_ATTENTE', 'CONFIRME', 'TERMINE', 'ANNULE')),
                     notes TEXT,
                     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                     updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                     CONSTRAINT fk_rdv_patient FOREIGN KEY (patient_id) REFERENCES patient(id) ON DELETE CASCADE ON UPDATE CASCADE,
                     CONSTRAINT fk_rdv_medecin FOREIGN KEY (medecin_id) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE CASCADE,
                     CONSTRAINT chk_rdv_heure CHECK (heure_fin > heure_debut)
) ENGINE=InnoDB;
CREATE INDEX idx_rdv_medecin_date ON rdv(medecin_id, date_rdv);

-- ==============================================================================
-- MODULE MÉDICAL
-- ==============================================================================

-- Catalogue des actes
CREATE TABLE acte (
                      id BIGINT AUTO_INCREMENT PRIMARY KEY,
                      code VARCHAR(20) NOT NULL UNIQUE,
                      libelle VARCHAR(150) NOT NULL,
                      prix DECIMAL(10,2) NOT NULL CHECK (prix >= 0),
                      duree_min INT DEFAULT 30,
                      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Table des consultations
CREATE TABLE consultation (
                              id BIGINT AUTO_INCREMENT PRIMARY KEY,
                              patient_id BIGINT NOT NULL,
                              medecin_id BIGINT NOT NULL,
                              rdv_id BIGINT UNIQUE,
                              date_consultation DATETIME NOT NULL,
                              motif VARCHAR(255),
                              diagnostic TEXT,
                              observations TEXT,
                              created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                              updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                              CONSTRAINT fk_consultation_patient FOREIGN KEY (patient_id) REFERENCES patient(id) ON DELETE RESTRICT ON UPDATE CASCADE,
                              CONSTRAINT fk_consultation_medecin FOREIGN KEY (medecin_id) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE CASCADE,
                              CONSTRAINT fk_consultation_rdv FOREIGN KEY (rdv_id) REFERENCES rdv(id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Table des dents (schéma FDI)
CREATE TABLE dent (
                      id BIGINT AUTO_INCREMENT PRIMARY KEY,
                      numero INT NOT NULL UNIQUE CHECK (numero BETWEEN 11 AND 48),
                      quadrant INT NOT NULL,
                      position VARCHAR(50)
) ENGINE=InnoDB;

-- Table des interventions médicales
CREATE TABLE intervention_medicale (
                                       id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                       consultation_id BIGINT NOT NULL,
                                       dent_id BIGINT,
                                       acte_id BIGINT NOT NULL,
                                       prix_applique DECIMAL(10,2) NOT NULL CHECK (prix_applique >= 0),
                                       remarque TEXT,
                                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                       updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                       CONSTRAINT fk_intervention_consultation FOREIGN KEY (consultation_id) REFERENCES consultation(id) ON DELETE CASCADE ON UPDATE CASCADE,
                                       CONSTRAINT fk_intervention_dent FOREIGN KEY (dent_id) REFERENCES dent(id) ON DELETE SET NULL ON UPDATE CASCADE,
                                       CONSTRAINT fk_intervention_acte FOREIGN KEY (acte_id) REFERENCES acte(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Table des médicaments
CREATE TABLE medicament (
                            id BIGINT AUTO_INCREMENT PRIMARY KEY,
                            nom VARCHAR(100) NOT NULL,
                            dosage VARCHAR(50),
                            forme VARCHAR(50),
                            description TEXT,
                            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Table des ordonnances
CREATE TABLE ordonnance (
                            id BIGINT AUTO_INCREMENT PRIMARY KEY,
                            consultation_id BIGINT NOT NULL UNIQUE,
                            date_ordonnance DATE NOT NULL,
                            remarques TEXT,
                            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                            CONSTRAINT fk_ordonnance_consultation FOREIGN KEY (consultation_id) REFERENCES consultation(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Table des lignes d'ordonnance
CREATE TABLE ligne_ordonnance (
                                  id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                  ordonnance_id BIGINT NOT NULL,
                                  medicament_id BIGINT NOT NULL,
                                  posologie VARCHAR(255) NOT NULL,
                                  duree VARCHAR(50),
                                  quantite INT NOT NULL CHECK (quantite > 0),
                                  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                  CONSTRAINT fk_ligne_ordonnance_ordonnance FOREIGN KEY (ordonnance_id) REFERENCES ordonnance(id) ON DELETE CASCADE ON UPDATE CASCADE,
                                  CONSTRAINT fk_ligne_ordonnance_medicament FOREIGN KEY (medicament_id) REFERENCES medicament(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Table des certificats médicaux
CREATE TABLE certificat_medical (
                                    id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                    consultation_id BIGINT,
                                    patient_id BIGINT NOT NULL,
                                    date_emission DATE NOT NULL,
                                    contenu TEXT NOT NULL,
                                    duree_repos INT,
                                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                    CONSTRAINT fk_certificat_consultation FOREIGN KEY (consultation_id) REFERENCES consultation(id) ON DELETE SET NULL ON UPDATE CASCADE,
                                    CONSTRAINT fk_certificat_patient FOREIGN KEY (patient_id) REFERENCES patient(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ==============================================================================
-- MODULE FINANCE
-- ==============================================================================

-- Table des factures
CREATE TABLE facture (
                         id BIGINT AUTO_INCREMENT PRIMARY KEY,
                         numero_facture VARCHAR(50) NOT NULL UNIQUE,
                         patient_id BIGINT NOT NULL,
                         consultation_id BIGINT UNIQUE,
                         date_facture DATE NOT NULL,
                         montant_total DECIMAL(10,2) NOT NULL CHECK (montant_total >= 0),
                         montant_paye DECIMAL(10,2) DEFAULT 0.00 CHECK (montant_paye >= 0),
                         statut VARCHAR(20) DEFAULT 'IMPAYEE' CHECK (statut IN ('IMPAYEE', 'PARTIELLE', 'PAYEE', 'ANNULEE')),
                         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                         CONSTRAINT fk_facture_patient FOREIGN KEY (patient_id) REFERENCES patient(id) ON DELETE RESTRICT ON UPDATE CASCADE,
                         CONSTRAINT fk_facture_consultation FOREIGN KEY (consultation_id) REFERENCES consultation(id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;
CREATE INDEX idx_facture_statut ON facture(statut);

-- Table des lignes de facture
CREATE TABLE ligne_facture (
                               id BIGINT AUTO_INCREMENT PRIMARY KEY,
                               facture_id BIGINT NOT NULL,
                               description VARCHAR(255) NOT NULL,
                               quantite INT NOT NULL DEFAULT 1 CHECK (quantite > 0),
                               prix_unitaire DECIMAL(10,2) NOT NULL CHECK (prix_unitaire >= 0),
                               montant_ligne DECIMAL(10,2) NOT NULL CHECK (montant_ligne >= 0),
                               created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                               updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                               CONSTRAINT fk_ligne_facture_facture FOREIGN KEY (facture_id) REFERENCES facture(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Table des paiements
CREATE TABLE paiement (
                          id BIGINT AUTO_INCREMENT PRIMARY KEY,
                          facture_id BIGINT NOT NULL,
                          date_paiement DATETIME NOT NULL,
                          montant DECIMAL(10,2) NOT NULL CHECK (montant > 0),
                          mode_paiement VARCHAR(20) NOT NULL,
                          reference VARCHAR(100),
                          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                          CONSTRAINT fk_paiement_facture FOREIGN KEY (facture_id) REFERENCES facture(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Table des comptes patients (Crédits)
CREATE TABLE compte_patient (
                                id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                patient_id BIGINT NOT NULL UNIQUE,
                                solde_credit DECIMAL(10,2) DEFAULT 0.00 CHECK (solde_credit >= 0),
                                plafond_credit DECIMAL(10,2) DEFAULT 0.00, -- HYP: Ajouté suite au diagramme
                                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                CONSTRAINT fk_compte_patient FOREIGN KEY (patient_id) REFERENCES patient(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;