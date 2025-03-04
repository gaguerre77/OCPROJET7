import { LightningElement, wire } from 'lwc';
import getLivraisons from '@salesforce/apex/LivraisonController.getLivraisons';

const COLUMNS = [
    { label: 'Numéro de Livraison', fieldName: 'Name', type: 'text' },
    { label: 'Pays de Destination', fieldName: 'PaysDestination__c', type: 'text' },
    {
        label: 'Meilleur Prix',
        type: 'button-icon',
        typeAttributes: {
            iconName: 'utility:moneybag',
            variant: 'border-filled',
            alternativeText: 'Dollar'
        }
    },
    {
        label: 'Meilleur Delai',
        type: 'button-icon',
        typeAttributes: {
            iconName: 'utility:reminder',
            variant: 'border-filled',
            alternativeText: 'Camion'
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

    showError(error) {
        console.error(error);
    }
}
