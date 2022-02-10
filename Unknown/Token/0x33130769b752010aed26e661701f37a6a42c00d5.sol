['pragma solidity ^0.4.13;\n', '\n', 'interface IERC20 {\n', '  function totalSupply() constant returns (uint totalSupply);\n', '  function balanceOf(address _owner) constant returns (uint balance);\n', '  function transfer(address _to, uint _value) returns (bool success);\n', '  function transferFrom(address _from, address _to, uint _value) returns (bool success);\n', '  function approve(address _spender, uint _value) returns (bool success);\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining);\n', '  event Transfer(address indexed _from, address indexed _to, uint _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', '\n', '/**\n', '* @title SafeMath\n', '* @dev Math operations with safety checks that throw on error\n', '*/\n', 'library SafeMath {\n', 'function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '  uint256 c = a * b;\n', '  assert(a == 0 || c / a == b);\n', '  return c;\n', '}\n', '\n', 'function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '  // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '  uint256 c = a / b;\n', '  // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '  return c;\n', '}\n', '\n', 'function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '  assert(b <= a);\n', '  return a - b;\n', '}\n', '\n', 'function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '  uint256 c = a + b;\n', '  assert(c >= a);\n', '  return c;\n', '}\n', '}\n', '\n', 'contract BitClemm is IERC20{\n', ' using SafeMath for uint256;\n', ' \n', ' uint256 public _totalSupply = 0;\n', ' \n', ' \n', ' string public symbol = "BCM";//Simbolo del token es. ETH\n', ' string public constant name = "BitClemm"; //Nome del token es. Ethereum\n', ' uint256 public constant decimals = 3; //Numero di decimali del token, il bitcoin ne ha 8, ethereum 18\n', ' \n', ' uint256 public MAX_SUPPLY = 180000000 * 10**decimals; //Numero massimo di token da emettere ( 1000 )\n', ' uint256 public TOKEN_TO_CREATOR = 9000000 * 10**decimals; //Token da inviare al creatore del contratto\n', '\n', ' uint256 public constant RATE = 1000; //Quanti token inviare per ogni ether ricevuto\n', ' address public owner;\n', ' \n', ' mapping(address => uint256) balances;\n', ' mapping(address => mapping(address => uint256)) allowed;\n', ' \n', ' //Funzione che permette di ricevere token solo specificando l&#39;indirizzo\n', ' function() payable{\n', '     createTokens();\n', ' }\n', ' \n', ' //Salviamo l&#39;indirizzo del creatore del contratto per inviare gli ether ricevuti\n', ' function BitClemm(){\n', '     owner = msg.sender;\n', '     balances[msg.sender] = TOKEN_TO_CREATOR;\n', '     _totalSupply = _totalSupply.add(TOKEN_TO_CREATOR);\n', ' }\n', ' \n', ' //Creazione dei token\n', ' function createTokens() payable{\n', '     //Controlliamo che gli ether ricevuti siano maggiori di 0\n', '     require(msg.value >= 0);\n', '     \n', '     //Creiamo una variabile che contiene gli ether ricevuti moltiplicati per il RATE\n', '     uint256 tokens = msg.value.mul(10 ** decimals);\n', '     tokens = tokens.mul(RATE);\n', '     tokens = tokens.div(10 ** 18);\n', '\n', '     uint256 sum = _totalSupply.add(tokens);\n', '     require(sum <= MAX_SUPPLY);\n', '     //Aggiungiamo i token al bilancio di chi ci ha inviato gli ether ed aumentiamo la variabile totalSupply\n', '     balances[msg.sender] = balances[msg.sender].add(tokens);\n', '     _totalSupply = sum;\n', '     \n', '     //Inviamo gli ether a chi ha creato il contratto\n', '     owner.transfer(msg.value);\n', ' }\n', '\n', ' \n', ' //Ritorna il numero totale di token\n', ' function totalSupply() constant returns (uint totalSupply){\n', '     return _totalSupply;\n', ' }\n', ' \n', ' //Ritorna il bilancio dell&#39;utente di un indirizzo\n', ' function balanceOf(address _owner) constant returns (uint balance){\n', '     return balances[_owner];\n', ' }\n', ' \n', ' //Per inviare i Token\n', ' function transfer(address _to, uint256 _value) returns (bool success){\n', '     //Controlliamo che chi voglia inviare i token ne abbia a sufficienza e che ne voglia inviare pi&#249; di 0\n', '     require(\n', '         balances[msg.sender] >= _value\n', '         && _value > 0\n', '     );\n', '     //Togliamo i token inviati dal suo bilancio\n', '     balances[msg.sender] = balances[msg.sender].sub(_value);\n', '     //Li aggiungiamo al bilancio del ricevente\n', '     balances[_to] = balances[_to].add(_value);\n', '     //Chiamiamo l evento transfer\n', '     Transfer(msg.sender, _to, _value);\n', '     return true;\n', ' }\n', ' \n', ' //Invio dei token con delega\n', ' function transferFrom(address _from, address _to, uint256 _value) returns (bool success){\n', '     //Controlliamo che chi voglia inviare token da un indirizzo non suo abbia la delega per farlo, che\n', '     //l&#39;account da dove vngono inviati i token abbia token a sufficienza e\n', '     //che i token inviati siano maggiori di 0\n', '     require(\n', '         allowed[_from][msg.sender] >= _value\n', '         && balances[msg.sender] >= _value\n', '         && _value > 0\n', '     );\n', '     //togliamo i token da chi li invia\n', '     balances[_from] = balances[_from].sub(_value);\n', '     //Aggiungiamoli al rcevente\n', '     balances[_to] = balances[_to].add(_value);\n', '     //Diminuiamo il valore dei token che il delegato pu&#242; inviare in favore del delegante\n', '     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '     //Chiamaiamo l&#39;evento transfer\n', '     Transfer(_from, _to, _value);\n', '     return true;\n', ' }\n', ' \n', ' //Delegare qualcuno all&#39;invio di token\n', ' function approve(address _spender, uint256 _value) returns (bool success){\n', '     //Inseriamo l&#39;indirizzo del delegato e il massimo che pu&#242; inviare\n', '     allowed[msg.sender][_spender] = _value;\n', '     //Chiamiamo l&#39;evento approval\n', '     Approval(msg.sender, _spender, _value);\n', '     return true;\n', ' }\n', ' \n', ' //Ritorna il numero di token che un delegato pu&#242; ancora inviare\n', ' function allowance(address _owner, address _spender) constant returns (uint remaining){\n', '     return allowed[_owner][_spender];\n', ' }\n', '\n', ' event Transfer(address indexed _from, address indexed _to, uint _value);\n', ' event Approval(address indexed _owner, address indexed _spender, uint _value);\n', ' \n', '}']
['pragma solidity ^0.4.13;\n', '\n', 'interface IERC20 {\n', '  function totalSupply() constant returns (uint totalSupply);\n', '  function balanceOf(address _owner) constant returns (uint balance);\n', '  function transfer(address _to, uint _value) returns (bool success);\n', '  function transferFrom(address _from, address _to, uint _value) returns (bool success);\n', '  function approve(address _spender, uint _value) returns (bool success);\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining);\n', '  event Transfer(address indexed _from, address indexed _to, uint _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', '\n', '/**\n', '* @title SafeMath\n', '* @dev Math operations with safety checks that throw on error\n', '*/\n', 'library SafeMath {\n', 'function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '  uint256 c = a * b;\n', '  assert(a == 0 || c / a == b);\n', '  return c;\n', '}\n', '\n', 'function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '  // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '  uint256 c = a / b;\n', "  // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '  return c;\n', '}\n', '\n', 'function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '  assert(b <= a);\n', '  return a - b;\n', '}\n', '\n', 'function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '  uint256 c = a + b;\n', '  assert(c >= a);\n', '  return c;\n', '}\n', '}\n', '\n', 'contract BitClemm is IERC20{\n', ' using SafeMath for uint256;\n', ' \n', ' uint256 public _totalSupply = 0;\n', ' \n', ' \n', ' string public symbol = "BCM";//Simbolo del token es. ETH\n', ' string public constant name = "BitClemm"; //Nome del token es. Ethereum\n', ' uint256 public constant decimals = 3; //Numero di decimali del token, il bitcoin ne ha 8, ethereum 18\n', ' \n', ' uint256 public MAX_SUPPLY = 180000000 * 10**decimals; //Numero massimo di token da emettere ( 1000 )\n', ' uint256 public TOKEN_TO_CREATOR = 9000000 * 10**decimals; //Token da inviare al creatore del contratto\n', '\n', ' uint256 public constant RATE = 1000; //Quanti token inviare per ogni ether ricevuto\n', ' address public owner;\n', ' \n', ' mapping(address => uint256) balances;\n', ' mapping(address => mapping(address => uint256)) allowed;\n', ' \n', " //Funzione che permette di ricevere token solo specificando l'indirizzo\n", ' function() payable{\n', '     createTokens();\n', ' }\n', ' \n', " //Salviamo l'indirizzo del creatore del contratto per inviare gli ether ricevuti\n", ' function BitClemm(){\n', '     owner = msg.sender;\n', '     balances[msg.sender] = TOKEN_TO_CREATOR;\n', '     _totalSupply = _totalSupply.add(TOKEN_TO_CREATOR);\n', ' }\n', ' \n', ' //Creazione dei token\n', ' function createTokens() payable{\n', '     //Controlliamo che gli ether ricevuti siano maggiori di 0\n', '     require(msg.value >= 0);\n', '     \n', '     //Creiamo una variabile che contiene gli ether ricevuti moltiplicati per il RATE\n', '     uint256 tokens = msg.value.mul(10 ** decimals);\n', '     tokens = tokens.mul(RATE);\n', '     tokens = tokens.div(10 ** 18);\n', '\n', '     uint256 sum = _totalSupply.add(tokens);\n', '     require(sum <= MAX_SUPPLY);\n', '     //Aggiungiamo i token al bilancio di chi ci ha inviato gli ether ed aumentiamo la variabile totalSupply\n', '     balances[msg.sender] = balances[msg.sender].add(tokens);\n', '     _totalSupply = sum;\n', '     \n', '     //Inviamo gli ether a chi ha creato il contratto\n', '     owner.transfer(msg.value);\n', ' }\n', '\n', ' \n', ' //Ritorna il numero totale di token\n', ' function totalSupply() constant returns (uint totalSupply){\n', '     return _totalSupply;\n', ' }\n', ' \n', " //Ritorna il bilancio dell'utente di un indirizzo\n", ' function balanceOf(address _owner) constant returns (uint balance){\n', '     return balances[_owner];\n', ' }\n', ' \n', ' //Per inviare i Token\n', ' function transfer(address _to, uint256 _value) returns (bool success){\n', '     //Controlliamo che chi voglia inviare i token ne abbia a sufficienza e che ne voglia inviare più di 0\n', '     require(\n', '         balances[msg.sender] >= _value\n', '         && _value > 0\n', '     );\n', '     //Togliamo i token inviati dal suo bilancio\n', '     balances[msg.sender] = balances[msg.sender].sub(_value);\n', '     //Li aggiungiamo al bilancio del ricevente\n', '     balances[_to] = balances[_to].add(_value);\n', '     //Chiamiamo l evento transfer\n', '     Transfer(msg.sender, _to, _value);\n', '     return true;\n', ' }\n', ' \n', ' //Invio dei token con delega\n', ' function transferFrom(address _from, address _to, uint256 _value) returns (bool success){\n', '     //Controlliamo che chi voglia inviare token da un indirizzo non suo abbia la delega per farlo, che\n', "     //l'account da dove vngono inviati i token abbia token a sufficienza e\n", '     //che i token inviati siano maggiori di 0\n', '     require(\n', '         allowed[_from][msg.sender] >= _value\n', '         && balances[msg.sender] >= _value\n', '         && _value > 0\n', '     );\n', '     //togliamo i token da chi li invia\n', '     balances[_from] = balances[_from].sub(_value);\n', '     //Aggiungiamoli al rcevente\n', '     balances[_to] = balances[_to].add(_value);\n', '     //Diminuiamo il valore dei token che il delegato può inviare in favore del delegante\n', '     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', "     //Chiamaiamo l'evento transfer\n", '     Transfer(_from, _to, _value);\n', '     return true;\n', ' }\n', ' \n', " //Delegare qualcuno all'invio di token\n", ' function approve(address _spender, uint256 _value) returns (bool success){\n', "     //Inseriamo l'indirizzo del delegato e il massimo che può inviare\n", '     allowed[msg.sender][_spender] = _value;\n', "     //Chiamiamo l'evento approval\n", '     Approval(msg.sender, _spender, _value);\n', '     return true;\n', ' }\n', ' \n', ' //Ritorna il numero di token che un delegato può ancora inviare\n', ' function allowance(address _owner, address _spender) constant returns (uint remaining){\n', '     return allowed[_owner][_spender];\n', ' }\n', '\n', ' event Transfer(address indexed _from, address indexed _to, uint _value);\n', ' event Approval(address indexed _owner, address indexed _spender, uint _value);\n', ' \n', '}']
