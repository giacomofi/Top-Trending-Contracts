['pragma solidity ^0.4.16;\n', '\n', 'contract owned {\n', '    address public owner;\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }\n', '\n', 'contract TokenMomos is owned{\n', '\n', '    string public name = "Momocoin";\n', '    string public symbol = "MOMO";\n', '    uint8 public decimals = 18;\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '    \n', '    uint256 public totalSupply;\n', '\n', '    bytes32 public currentChallenge;  \n', '    uint256 public timeOfLastProof;                             \n', '    uint256 public difficulty = 10**32;   \n', '    \n', '    // Esto genera un evento p&#250;blico en el blockchain que notificar&#225; a los clientes\n', '    event Transfer(address indexed from, address indexed to, uint256 value); //Va de ley, no quitar\n', '    \n', '    // Esto genera un evento p&#250;blico en el blockchain que notificar&#225; a los clientes\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value); //Va de ley, no quitar\n', '\n', '    // Esto notifica a los clientes sobre la cantidad quemada\n', '    event Burn(address indexed from, uint256 value);\n', '    \n', '    constructor(uint256 momos) public {\n', '        totalSupply = momos * 10 ** uint256(decimals);  // Actualizar el suministro total con la cantidad decimal\n', '        balanceOf[msg.sender] = totalSupply;            // Dale al creador todos los tokens iniciales\n', '        timeOfLastProof = now;\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // Impedir la transferencia a la direcci&#243;n 0x0.\n', '        require(_to != 0x0);\n', '        // Verifica si el remitente tiene suficiente\n', '        require(balanceOf[_from] >= _value);\n', '         // Verificar desbordamientos\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        // Guarda esto para una afirmaci&#243;n en el futuro\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '         // Resta del remitente\n', '        balanceOf[_from] -= _value;\n', '        // Agregue lo mismo al destinatario\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '         // Los asertos se usan para usar an&#225;lisis est&#225;ticos para encontrar errores en su c&#243;digo. Nunca deber&#237;an fallar\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   // Verifica si el remitente tiene suficiente\n', '        balanceOf[msg.sender] -= _value;            // Resta del remitente\n', '        totalSupply -= _value;                      // Actualiza totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                // Verifica si el saldo objetivo es suficiente\n', '        require(_value <= allowance[_from][msg.sender]);    // Verifique la asignaci&#243;n\n', '        balanceOf[_from] -= _value;                         // Resta del saldo objetivo\n', '        allowance[_from][msg.sender] -= _value;             // Resta del subsidio del remitente\n', '        totalSupply -= _value;                              // Actualizar totalSupply\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '\n', '    function () external {\n', '        revert();     // Previene el env&#237;o accidental de &#233;ter\n', '    }\n', '    \n', '    function giveBlockReward() public {\n', '        balanceOf[block.coinbase] += 1;\n', '    }\n', '\n', '    function proofOfWork(uint256 nonce) public{\n', '        bytes8 n = bytes8(keccak256(abi.encodePacked(nonce, currentChallenge)));    \n', '        require(n >= bytes8(difficulty));                   \n', '        uint256 timeSinceLastProof = (now - timeOfLastProof);  \n', '        require(timeSinceLastProof >=  5 seconds);         \n', '        balanceOf[msg.sender] += timeSinceLastProof / 60 seconds;  \n', '        difficulty = difficulty * 10 minutes / timeSinceLastProof + 1; \n', '        timeOfLastProof = now;                              \n', '        currentChallenge = keccak256(abi.encodePacked(nonce, currentChallenge, blockhash(block.number - 1)));  \n', '    }\n', '}']
['pragma solidity ^0.4.16;\n', '\n', 'contract owned {\n', '    address public owner;\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }\n', '\n', 'contract TokenMomos is owned{\n', '\n', '    string public name = "Momocoin";\n', '    string public symbol = "MOMO";\n', '    uint8 public decimals = 18;\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '    \n', '    uint256 public totalSupply;\n', '\n', '    bytes32 public currentChallenge;  \n', '    uint256 public timeOfLastProof;                             \n', '    uint256 public difficulty = 10**32;   \n', '    \n', '    // Esto genera un evento público en el blockchain que notificará a los clientes\n', '    event Transfer(address indexed from, address indexed to, uint256 value); //Va de ley, no quitar\n', '    \n', '    // Esto genera un evento público en el blockchain que notificará a los clientes\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value); //Va de ley, no quitar\n', '\n', '    // Esto notifica a los clientes sobre la cantidad quemada\n', '    event Burn(address indexed from, uint256 value);\n', '    \n', '    constructor(uint256 momos) public {\n', '        totalSupply = momos * 10 ** uint256(decimals);  // Actualizar el suministro total con la cantidad decimal\n', '        balanceOf[msg.sender] = totalSupply;            // Dale al creador todos los tokens iniciales\n', '        timeOfLastProof = now;\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // Impedir la transferencia a la dirección 0x0.\n', '        require(_to != 0x0);\n', '        // Verifica si el remitente tiene suficiente\n', '        require(balanceOf[_from] >= _value);\n', '         // Verificar desbordamientos\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        // Guarda esto para una afirmación en el futuro\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '         // Resta del remitente\n', '        balanceOf[_from] -= _value;\n', '        // Agregue lo mismo al destinatario\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '         // Los asertos se usan para usar análisis estáticos para encontrar errores en su código. Nunca deberían fallar\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   // Verifica si el remitente tiene suficiente\n', '        balanceOf[msg.sender] -= _value;            // Resta del remitente\n', '        totalSupply -= _value;                      // Actualiza totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                // Verifica si el saldo objetivo es suficiente\n', '        require(_value <= allowance[_from][msg.sender]);    // Verifique la asignación\n', '        balanceOf[_from] -= _value;                         // Resta del saldo objetivo\n', '        allowance[_from][msg.sender] -= _value;             // Resta del subsidio del remitente\n', '        totalSupply -= _value;                              // Actualizar totalSupply\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '\n', '    function () external {\n', '        revert();     // Previene el envío accidental de éter\n', '    }\n', '    \n', '    function giveBlockReward() public {\n', '        balanceOf[block.coinbase] += 1;\n', '    }\n', '\n', '    function proofOfWork(uint256 nonce) public{\n', '        bytes8 n = bytes8(keccak256(abi.encodePacked(nonce, currentChallenge)));    \n', '        require(n >= bytes8(difficulty));                   \n', '        uint256 timeSinceLastProof = (now - timeOfLastProof);  \n', '        require(timeSinceLastProof >=  5 seconds);         \n', '        balanceOf[msg.sender] += timeSinceLastProof / 60 seconds;  \n', '        difficulty = difficulty * 10 minutes / timeSinceLastProof + 1; \n', '        timeOfLastProof = now;                              \n', '        currentChallenge = keccak256(abi.encodePacked(nonce, currentChallenge, blockhash(block.number - 1)));  \n', '    }\n', '}']
