['pragma solidity ^0.4.24;\n', '\n', 'contract FamilienSpardose {\n', '    \n', '    // Created by N. Fuchs\n', '    \n', '    // Name der Familienspardose\n', '    string public spardosenName;\n', '    \n', '    //weist einer Addresse ein Guthaben zu\n', '    mapping (address => uint) public guthaben;\n', '    \n', '    // zeigt im smart contract an, wieviel Ether alle Sparer insgesamt halten\n', '    // ".balance" ist eine Objektattribut des Datentyps address, das f&#252;r jede wallet und jeden smart contract das entsprechende \n', '    //  Ether-Guthaben darstellt.\n', '    uint public gesamtGuthaben = address(this).balance;\n', '    \n', '    // Konstruktorfunktion: Wird einmalig beim deployment des smart contracts ausgef&#252;hrt\n', '    // Wenn Transaktionen, die Funktionen auszuf&#252;hren beabsichtigen, Ether mitgesendet wird (TXvalue > 0), so muss die\n', '    //  ausgef&#252;hrte Transaktion mit "payable" gekennzeichnet sein. Sicherheitsfeature im Interesse der Nutzer\n', '    constructor(string _name, address _sparer) payable {\n', '        \n', '        \n', '        // Weist der Variablen spardosenName den String _name zu, welcher vom Ersteller\n', '        // des smart contracts als Parameter in der Transaktion &#252;bergeben wird:\n', '        spardosenName = _name;\n', '        \n', '        \n', '        // Erstellt einen unsignierten integer, der mit der Menge Ether definiert wird, die der \n', '        // Transaktion mitgeliefert wird:\n', '        uint startGuthaben = msg.value;\n', '        \n', '        // Wenn der ersteller des smart contracts in der transaktion einen Beg&#252;nstigten angegeben hat, soll ihm \n', '        // der zuvor als Startguthaben definierte Wert als Guthaben gutgeschrieben werden.\n', '        // Das mitgesendete Ether wird dabei dem smart contract gutgeschrieben, er war der Empf&#228;nger der Transaktion.\n', '        if (_sparer != 0x0) guthaben[_sparer] = startGuthaben;\n', '        else guthaben[msg.sender] = startGuthaben;\n', '    }\n', '    \n', '    \n', '    // Schreibt dem Absender der Transaktion (TXfrom) ihren Wert (TXvalue) als Guthaben zu\n', '    function einzahlen() public payable{\n', '        guthaben[msg.sender] = msg.value;\n', '    }\n', '    \n', '    // Erm&#246;glicht jemandem, so viel Ether aus dem smart contract abzubuchen, wie ihm an Guthaben zur Verf&#252;gung steht\n', '    function abbuchen(uint _betrag) public {\n', '        \n', '        // Zun&#228;chst pr&#252;fen, ob dieser jemand &#252;ber ausreichend Guthaben verf&#252;gt.\n', '        // Wird diese Bedingung nicht erf&#252;llt, wird die Ausf&#252;hrung der Funktion abgebrochen.\n', '        require(guthaben[msg.sender] >= _betrag);\n', '        \n', '        // Subtrahieren des abzuhebenden Guthabens \n', '        guthaben [msg.sender] = guthaben [msg.sender] - _betrag;\n', '        \n', '        // &#220;berweisung des Ethers\n', '        // ".transfer" ist eine Objektmethode des Datentyps address, die an die gegebene Addresse \n', '        // die gew&#252;nschte Menge Ether zu transferieren versucht. Schl&#228;gt dies fehl, wird die\n', '        // Ausf&#252;hrung der Funktion abgebrochen und bisherige &#196;nderungen r&#252;ckg&#228;ngig gemacht.\n', '        msg.sender.transfer(_betrag);\n', '    }\n', '    \n', '    // Getter-Funktion; Gibt das Guthaben einer Addresse zur&#252;ck.\n', '    // Dient der Veranschaulichung von Funktionen, die den state nicht ver&#228;ndern.\n', '    // Nicht explizit notwendig, da jede als public Variable, so auch das mapping guthaben,\n', '    // vom compiler eine automatische, gleichnamige Getter-Funktion erhalten, wenn sie als public\n', '    // deklariert sind.\n', '    function guthabenAnzeigen(address _sparer) view returns (uint) {\n', '        return guthaben[_sparer];\n', '    }\n', '    \n', '    // Eine weitere Veranschaulichung eines Funktionstyps, der den state nicht &#228;ndert. \n', '    // Weil mit pure gekennzeichnete Funktionen auf den state sogar garnicht nicht zugreifen k&#246;nnen,\n', '    // werden entsprechende opcodes nicht ben&#246;tigt und der smart contract kostet weniger Guthabens\n', '    // beim deployment ben&#246;tigt. \n', '    function addieren(uint _menge1, uint _menge2) pure returns (uint) {\n', '        return _menge1 + _menge2;\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', 'contract FamilienSpardose {\n', '    \n', '    // Created by N. Fuchs\n', '    \n', '    // Name der Familienspardose\n', '    string public spardosenName;\n', '    \n', '    //weist einer Addresse ein Guthaben zu\n', '    mapping (address => uint) public guthaben;\n', '    \n', '    // zeigt im smart contract an, wieviel Ether alle Sparer insgesamt halten\n', '    // ".balance" ist eine Objektattribut des Datentyps address, das für jede wallet und jeden smart contract das entsprechende \n', '    //  Ether-Guthaben darstellt.\n', '    uint public gesamtGuthaben = address(this).balance;\n', '    \n', '    // Konstruktorfunktion: Wird einmalig beim deployment des smart contracts ausgeführt\n', '    // Wenn Transaktionen, die Funktionen auszuführen beabsichtigen, Ether mitgesendet wird (TXvalue > 0), so muss die\n', '    //  ausgeführte Transaktion mit "payable" gekennzeichnet sein. Sicherheitsfeature im Interesse der Nutzer\n', '    constructor(string _name, address _sparer) payable {\n', '        \n', '        \n', '        // Weist der Variablen spardosenName den String _name zu, welcher vom Ersteller\n', '        // des smart contracts als Parameter in der Transaktion übergeben wird:\n', '        spardosenName = _name;\n', '        \n', '        \n', '        // Erstellt einen unsignierten integer, der mit der Menge Ether definiert wird, die der \n', '        // Transaktion mitgeliefert wird:\n', '        uint startGuthaben = msg.value;\n', '        \n', '        // Wenn der ersteller des smart contracts in der transaktion einen Begünstigten angegeben hat, soll ihm \n', '        // der zuvor als Startguthaben definierte Wert als Guthaben gutgeschrieben werden.\n', '        // Das mitgesendete Ether wird dabei dem smart contract gutgeschrieben, er war der Empfänger der Transaktion.\n', '        if (_sparer != 0x0) guthaben[_sparer] = startGuthaben;\n', '        else guthaben[msg.sender] = startGuthaben;\n', '    }\n', '    \n', '    \n', '    // Schreibt dem Absender der Transaktion (TXfrom) ihren Wert (TXvalue) als Guthaben zu\n', '    function einzahlen() public payable{\n', '        guthaben[msg.sender] = msg.value;\n', '    }\n', '    \n', '    // Ermöglicht jemandem, so viel Ether aus dem smart contract abzubuchen, wie ihm an Guthaben zur Verfügung steht\n', '    function abbuchen(uint _betrag) public {\n', '        \n', '        // Zunächst prüfen, ob dieser jemand über ausreichend Guthaben verfügt.\n', '        // Wird diese Bedingung nicht erfüllt, wird die Ausführung der Funktion abgebrochen.\n', '        require(guthaben[msg.sender] >= _betrag);\n', '        \n', '        // Subtrahieren des abzuhebenden Guthabens \n', '        guthaben [msg.sender] = guthaben [msg.sender] - _betrag;\n', '        \n', '        // Überweisung des Ethers\n', '        // ".transfer" ist eine Objektmethode des Datentyps address, die an die gegebene Addresse \n', '        // die gewünschte Menge Ether zu transferieren versucht. Schlägt dies fehl, wird die\n', '        // Ausführung der Funktion abgebrochen und bisherige Änderungen rückgängig gemacht.\n', '        msg.sender.transfer(_betrag);\n', '    }\n', '    \n', '    // Getter-Funktion; Gibt das Guthaben einer Addresse zurück.\n', '    // Dient der Veranschaulichung von Funktionen, die den state nicht verändern.\n', '    // Nicht explizit notwendig, da jede als public Variable, so auch das mapping guthaben,\n', '    // vom compiler eine automatische, gleichnamige Getter-Funktion erhalten, wenn sie als public\n', '    // deklariert sind.\n', '    function guthabenAnzeigen(address _sparer) view returns (uint) {\n', '        return guthaben[_sparer];\n', '    }\n', '    \n', '    // Eine weitere Veranschaulichung eines Funktionstyps, der den state nicht ändert. \n', '    // Weil mit pure gekennzeichnete Funktionen auf den state sogar garnicht nicht zugreifen können,\n', '    // werden entsprechende opcodes nicht benötigt und der smart contract kostet weniger Guthabens\n', '    // beim deployment benötigt. \n', '    function addieren(uint _menge1, uint _menge2) pure returns (uint) {\n', '        return _menge1 + _menge2;\n', '    }\n', '}']
