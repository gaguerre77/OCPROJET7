import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getLivraisons from '@salesforce/apex/LivraisonController.getLivraisons';
import completeLivraisonMeilleurPrix from '@salesforce/apex/LivraisonController.completeLivraisonMeilleurPrix';
import completeLivraisonMeilleurDelai from '@salesforce/apex/LivraisonController.completeLivraisonMeilleurDelai';

const COLUMNS = [
    { label: 'Numéro de Livraison', fieldName: 'Name', type: 'text' },
    { label: 'Pays de Destination', fieldName: 'PaysDestination__c', type: 'text' },
    {
        label: 'Meilleur Prix',
        type: 'button-icon',
        typeAttributes: {
            iconName: 'utility:moneybag',
            variant: 'border-filled',
            alternativeText: 'Dollar',
            name: 'meilleur_prix',
            title: 'Compléter avec le meilleur prix'
        }
    },
    {
        label: 'Meilleur Delai',
        type: 'button-icon',
        typeAttributes: {
            iconName: 'utility:reminder',
            variant: 'border-filled',
            alternativeText: 'Camion',
            name: 'meilleur_delai',
            title: 'Compléter avec le meilleur délai'
        }
    }
];

export default class TableauExpedition extends LightningElement {
    columns = COLUMNS;
    livraisons = [];

    @wire(getLivraisons)
    wiredLivraisons({ error, data }) {
        if (data) {
            this.livraisons = data;
        } else if (error) {
            this.showError(error);
        }
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;

        switch (actionName) {
            case 'meilleur_prix':
                this.completeLivraisonMeilleurPrix(row.Id);
                break;
            case 'meilleur_delai':
                this.completeLivraisonMeilleurDelai(row.Id);
                break;
            default:
                this.showError(`Action inconnue : ${actionName}`);
        }
    }

    completeLivraisonMeilleurPrix(livraisonId) {
        completeLivraisonMeilleurPrix({ livraisonId })
            .then(() => {
                this.showSuccessMessage('Livraison expédiée avec le meilleur prix');
                this.refreshLivraisons();
            })
            .catch(error => {
                this.showError(error);
            });
    }

    completeLivraisonMeilleurDelai(livraisonId) {
        completeLivraisonMeilleurDelai({ livraisonId })
            .then(() => {
                this.showSuccessMessage('Livraison expédiée avec le meilleur délai');
                this.refreshLivraisons();
            })
            .catch(error => {
                this.showError(error);
            });
    }

    refreshLivraisons() {
        return getLivraisons()
            .then(result => {
                this.livraisons = result;
            })
            .catch(error => {
                this.showError(error);
            });
    }

    showSuccessMessage(message) {
        const evt = new ShowToastEvent({
            title: 'Succès',
            message: message,
            variant: 'success',
        });
        this.dispatchEvent(evt);
    }

    showError(error) {
        console.error(error);
        const evt = new ShowToastEvent({
            title: 'Erreur',
            message: error.body.message || 'Une erreur inconnue est survenue.',
            variant: 'error',
        });
        this.dispatchEvent(evt);
    }
}
