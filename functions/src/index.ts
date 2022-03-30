import * as oauth from './oauth';
import * as getContacts from './get_contacts';

module.exports = {
    ...oauth,
    ...getContacts,
}