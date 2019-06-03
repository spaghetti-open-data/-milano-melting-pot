### funzioni python per riclassificare i record. Servono 



def assign_country(country):
    '''
    returns a tuple with the region and continent of country
    '''
    # elenco nazionalità, attribuite alla regione
    eu15 = ['Francia', 'Regno Unito', 'Spagna', 'Grecia', 'Portogallo', 'Germania', 'Belgio', 'Danimarca', 'Irlanda', 
        'Svezia', 'Austria', 'Paesi Bassi', 'Finlandia', 'Lussemburgo', 'Andorra', 'Monaco', 'Liechtenstein']
    eun13 = ['Bulgaria', 'Croazia', 'Romania', 'Ungheria', 'Estonia', 'Lituania', 'Polonia', 'Slovenia', 'Ceca, Rep.', 
         'Slovacchia', 'Lettonia', 'Malta', 'Cipro']
    otheu = ['Bosnia-Erzegovina', 'ex Jugoslavia', 'Albania', 'Georgia', 'Svizzera', 'Russa, Federazione', 'Ucraina', 
         'Norvegia', 'Moldova', 'Armenia', 'Islanda', 'Bielorussia', 'Azerbaigian', 'Kosovo', 'Serbia', 'Montenegro', 
         'Macedonia, ex Rep. Jugoslava']
    noraf = ['Egitto', 'Marocco', 'Tunisia', 'Libia', 'Algeria']
    ssaf = ['Etiopia', 'Togo', 'Mauritius', 'Eritrea', 'Somalia', 'Capo Verde', 'Ghana', 'Kenya', 'Nigeria', 'Ruanda', 
        'Senegal', 'Tanzania', 'Seychelles', 'Sudan', 'Sud Africa', "Costa D'Avorio", 'Camerun', 
        'Benin (ex Dahomey)', 'Burkina Faso (ex Alto Volta)', 'Zambia', 'Angola', 'Guinea', 'Gambia', 'Congo', 
        'Sierra Leone', 'Uganda', 'Burundi', 'Madagascar', 'Congo Rep. Dem (ex Zaire)', 'Gabon', 'Liberia', 
        'Mozambico', 'Mauritania', 'Mali', 'Zimbabwe (ex Rhodesia)', 'Gibuti', 'Niger', 'Ciad', 'Guinea Bissau', 
        'Centrafricana, Rep.', 'Sao Tomè e Principe', 'Malawi', 'Swaziland', 'Lesotho', 'Guinea Equatoriale', 
         'Sud Sudan, Repubblica del']
    eastas = ['Cinese, Rep. Popolare', 'Giappone', 'Taiwan (ex Formosa)', 'Corea del Sud, Rep.', 
          'Corea del Nord, Rep. Pop. Dem', 'Mongolia']
    southas = ['India', 'Bangladesh', 'Afghanistan', 'Bhutan', 'Maldive', 'Pakistan', 'Sri Lanka (ex Ceylon)', 'Nepal']
    seas = ['Indonesia', 'Malaysia', 'Vietnam', 'Singapore', 'Myanmar (ex Birmania)', 'Laos', 'Cambogia', 
        'Timor Orientale', 'Thailandia', 'Filippine']
    westas = ['Libano', 'Israele', 'Turchia', 'Iran', 'Siria', 'Iraq', 'Kazakistan', 'Uzbekistan', 'Yemen', 
          'Territori Autonomia Palestinese', 'Kuwait', 'Turkmenistan', 'Tagikistan', 'Kirghizistan', 'Oman']
    noram = ["Stati Uniti D'America", 'Canada', 'Giordania', 'Arabia Saudita']
    soam = ['Messico', 'Perù', 'El Salvador', 'Ecuador', 'Argentina', 'Cuba', 'Dominicana, Rep.', 'Colombia', 
        'Venezuela', 'Brasile', 'Dominica', 'Cile', 'Haiti', 'Bolivia', 'Uruguay', 'Costa Rica', 'Giamaica', 
       'Guatemala', 'Panama', 'Trinidad e Tobago', 'Nicaragua', 'Antigua e Barbuda', 'Suriname', 'Honduras', 
       'Bahamas', 'Barbados', 'Belize', 'Saint Kitts e Nevis', 'Paraguay']
    ocean = ['Australia', 'Nuova Zelanda']
    other = ['Altre nazioni o n.d.', 'Apolide']


    if country in eu15:
        location = ('eu15', 'europa')
    elif country in eun13:
        location = ('eun13', 'europa')
    elif country in otheu:
        location = ('otheu', 'europa')
    elif country in noraf:
        location = ('noraf', 'africa')
    elif country in ssaf:
        location = ('ssaf', 'africa')
    elif country in eastas:
        location = ('eastas', 'asia')
    elif country in southas:
        location = ('southas', 'asia')
    elif country in seas:
        location = ('seas', 'asia')
    elif country in westas:
        location = ('westas', 'asia')
    elif country in noram:
        location = ('noram', 'north america')
    elif country in soam:
        location = ('soam', 'south america')
    elif country in ocean:
        location = ('ocean', 'oceania')
    elif country in other:
        location = ('other','')
    else: 
        location = ('ita', 'italia')
    return location
    
if __name__ == '__main__':
    print('Hello world')