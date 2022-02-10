['pragma solidity ^0.4.24;\n', 'contract owned {\n', '    address public owner;\n', 'constructor() public {\n', '        owner = msg.sender;\n', '    }\n', 'modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', 'function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }\n', 'contract TokenERC20 {\n', '    // Variables públicos del token (hey, por ahora)\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 18;\n', '    uint256 public totalSupply;\n', '    // esto crea un array con todos los balances\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '    // estas dos lineas generan un evento público que notificará a todos los clientes\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    // quemamos?\n', '    event Burn(address indexed from, uint256 value);\n', '     /**\n', '     * \n', '     * Funcion constructor\n', '     *\n', '     **/\n', '    constructor(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol\n', '    ) public {\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);  //le da los 18 decimales\n', '        balanceOf[msg.sender] = totalSupply;                    // le da al creador toodo los tokens iniciales\n', '        name = tokenName;                                       // nombre del token\n', '        symbol = tokenSymbol;                                   // simbolo del token\n', '    }\n', '\n', '     /**\n', '     * transferencia interna, solo puede ser llamado desde este contrato\n', '     **/\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // previene la transferencia al address 0x0, las quema\n', '        require(_to != 0x0);\n', '        // chequear si el usuario tiene suficientes monedas\n', '        require(balanceOf[_from] >= _value);\n', '        // Chequear  por overflows\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        // Restarle al vendedor\n', '        balanceOf[_from] -= _value;\n', '        // Agregarle al comprador\n', '        balanceOf[_to] += _value;\n', '\t// se genera la transferencia\n', '        emit Transfer(_from, _to, _value);\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '/**\n', '     * Transferir monedas\n', '     *\n', '     * mandar `_value` tokens to `_to` desde tu cuenta\n', '     *\n', '     * @param _to el address del comprador\n', '     * @param _value la cantidad a vender\n', '**/\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '/**\n', '     * transferir cuentas desde otro adress\n', '     *\n', '     * mandar `_value` tokens a `_to` desde el address `_from`\n', '     *\n', '     * @param _from el address del vendedor\n', '     * @param _to el address del comprador\n', '     * @param _value la cantidad a vender\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '/**\n', '     * permitir para otros address\n', '     *\n', '     * permite al `_spender` a vender no mas `_value` tokens de los que tiene\n', '     *\n', '     * @param _spender el address autorizado a vender\n', '     * @param _value la cantidad máxima autorizada a vender\n', '**/\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '/**\n', '     * permitir a otros otros address y notificar\n', '     *\n', '     * permite al `_spender` a vender no mas `_value` tokens de los que tiene, y después genera un ping al contrato\n', '     *\n', '     * @param _spender el address autorizado a vender\n', '     * @param _value la cantidad máxima que puede vender\n', '     * @param _extraData algo de informacio extra para mandar el contrato aprobado\n', '**/\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '/**\n', '     * Destruir tokens\n', '     *\n', '     * destruye `_value` tokens del sistema irreversiblemente\n', '     *\n', '     * @param _value la cantidad de monedas a quemar\n', ' **/\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '/**\n', '     * destruye tokens de otra cuenta\n', '     *\n', '     * destruye `_value` tokens del sistema irreversiblemente desde la cuenta `_from`.\n', '     *\n', '     * @param _from el address del usuario \n', '     * @param _value la cantidad de monedas a quemar\n', '**/\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                // checkea si la cantidad a quemar es menor al address\n', '        require(_value <= allowance[_from][msg.sender]);    // checkea permisos\n', '        balanceOf[_from] -= _value;                         // resta del balarce\n', '        allowance[_from][msg.sender] -= _value;             // sustrae del que permite la quema\n', '        totalSupply -= _value;                              // Update totalSupply\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract YamanaNetwork is owned, TokenERC20 {\n', 'uint256 public sellPrice;\n', '    uint256 public buyPrice;\n', 'mapping (address => bool) public frozenAccount;\n', '/* Esto generea un evento publico en la blockchain que notifica clientes*/\n', '    event FrozenFunds(address target, bool frozen);\n', '/* inicia el contrato en el address del creador del contrato */\n', '    constructor(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol\n', '    ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}\n', '/* solo puede ser llamado desde este contrato */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require (_to != 0x0);                               \n', '        require (balanceOf[_from] >= _value);               \n', '        require (balanceOf[_to] + _value >= balanceOf[_to]); \n', '        require(!frozenAccount[_from]);                     \n', '        require(!frozenAccount[_to]);                      \n', '        balanceOf[_from] -= _value;                        \n', '        balanceOf[_to] += _value;                          \n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '    /// @notice Create `mintedAmount` tokens and send it to `target`\n', '    /// @param target Address to receive the tokens\n', '    /// @param mintedAmount the amount of tokens it will receive\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '        balanceOf[target] += mintedAmount;\n', '        totalSupply += mintedAmount;\n', '        emit Transfer(0, this, mintedAmount);\n', '        emit Transfer(this, target, mintedAmount);\n', '    }\n', '/// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens\n', '    /// @param target Address to be frozen\n', '    /// @param freeze either to freeze it or not\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '/// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth\n', '    /// @param newSellPrice Price the users can sell to the contract\n', '    /// @param newBuyPrice Price users can buy from the contract\n', '    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {\n', '        sellPrice = newSellPrice;\n', '        buyPrice = newBuyPrice;\n', '    }\n', '/// @notice Buy tokens from contract by sending ether\n', '    function buy() payable public {\n', '        uint amount = msg.value / buyPrice;               // calculates the amount\n', '        _transfer(this, msg.sender, amount);              // makes the transfers\n', '    }\n', '/// @notice Sell `amount` tokens to contract\n', '    /// @param amount amount of tokens to be sold\n', '    function sell(uint256 amount) public {\n', '        address myAddress = this;\n', '        require(myAddress.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy\n', '        _transfer(msg.sender, this, amount);              // makes the transfers\n', "        msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks\n", '    }\n', '}']