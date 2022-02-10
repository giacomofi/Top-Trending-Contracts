['pragma solidity ^0.4.23;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    /**\n', '      * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '      * account.\n', '      */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '      * @dev Throws if called by any account other than the owner.\n', '      */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20Basic {\n', '    uint public _totalSupply;\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address who) public constant returns (uint);\n', '    function transfer(address to, uint value) public;\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is Ownable, ERC20Basic {\n', '    using SafeMath for uint;\n', '\n', '    mapping(address => uint) public balances;\n', '\n', '    // additional variables for use if transaction fees ever became necessary\n', '    uint public basisPointsRate = 0;\n', '    uint public maximumFee = 0;\n', '\n', '    /**\n', '    * @dev Fix for the ERC20 short address attack.\n', '    */\n', '    modifier onlyPayloadSize(uint size) {\n', '        require(!(msg.data.length < size + 4));\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {\n', '        uint fee = (_value.mul(basisPointsRate)).div(10000);\n', '        if (fee > maximumFee) {\n', '            fee = maximumFee;\n', '        }\n', '        uint sendAmount = _value.sub(fee);\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(sendAmount);\n', '        if (fee > 0) {\n', '            balances[owner] = balances[owner].add(fee);\n', '            emit Transfer(msg.sender, owner, fee);\n', '        }\n', '        emit Transfer(msg.sender, _to, sendAmount);\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public constant returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public constant returns (uint);\n', '    function transferFrom(address from, address to, uint value) public;\n', '    function approve(address spender, uint value) public;\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based oncode by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is BasicToken, ERC20 {\n', '\n', '    mapping (address => mapping (address => uint)) public allowed;\n', '\n', '    uint public constant MAX_UINT = 2**256 - 1;\n', '\n', '    /**\n', '    * @dev Transfer tokens from one address to another\n', '    * @param _from address The address which you want to send tokens from\n', '    * @param _to address The address which you want to transfer to\n', '    * @param _value uint the amount of tokens to be transferred\n', '    */\n', '    function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {\n', '        var _allowance = allowed[_from][msg.sender];\n', '\n', '        // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '        // if (_value > _allowance) throw;\n', '\n', '        uint fee = (_value.mul(basisPointsRate)).div(10000);\n', '        if (fee > maximumFee) {\n', '            fee = maximumFee;\n', '        }\n', '        if (_allowance < MAX_UINT) {\n', '            allowed[_from][msg.sender] = _allowance.sub(_value);\n', '        }\n', '        uint sendAmount = _value.sub(fee);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(sendAmount);\n', '        if (fee > 0) {\n', '            balances[owner] = balances[owner].add(fee);\n', '            emit Transfer(_from, owner, fee);\n', '        }\n', '        emit Transfer(_from, _to, sendAmount);\n', '    }\n', '\n', '    /**\n', '    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _value The amount of tokens to be spent.\n', '    */\n', '    function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {\n', '\n', '        // To change the approve amount you first have to reduce the addresses`\n', '        //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '        //  already 0 to mitigate the race condition described here:\n', '        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '    }\n', '\n', '    /**\n', '    * @dev Function to check the amount of tokens than an owner allowed to a spender.\n', '    * @param _owner address The address which owns the funds.\n', '    * @param _spender address The address which will spend the funds.\n', '    * @return A uint specifying the amount of tokens still available for the spender.\n', '    */\n', '    function allowance(address _owner, address _spender) public constant returns (uint remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '}\n', '\n', 'contract UpgradedStandardToken is StandardToken{\n', '    // those methods are called by the legacy contract\n', '    // and they must ensure msg.sender to be the contract address\n', '    function transferByLegacy(address from, address to, uint value) public;\n', '    function transferFromByLegacy(address sender, address from, address spender, uint value) public;\n', '    function approveByLegacy(address from, address spender, uint value) public;\n', '}\n', '\n', 'contract BlackList is Ownable, BasicToken {\n', '\n', '    function getBlackListStatus(address _maker) external constant returns (bool) {\n', '        return isBlackListed[_maker];\n', '    }\n', '\n', '    function getOwner() external constant returns (address) {\n', '        return owner;\n', '    }\n', '\n', '    mapping (address => bool) public isBlackListed;\n', '    \n', '    function addBlackList (address _evilUser) public onlyOwner {\n', '        isBlackListed[_evilUser] = true;\n', '        emit AddedBlackList(_evilUser);\n', '    }\n', '\n', '    function removeBlackList (address _clearedUser) public onlyOwner {\n', '        isBlackListed[_clearedUser] = false;\n', '        emit RemovedBlackList(_clearedUser);\n', '    }\n', '\n', '    function destroyBlackFunds (address _blackListedUser) public onlyOwner {\n', '        require(isBlackListed[_blackListedUser]);\n', '        uint dirtyFunds = balanceOf(_blackListedUser);\n', '        balances[_blackListedUser] = 0;\n', '        //Posible Error\n', '        _totalSupply -= dirtyFunds;\n', '        emit DestroyedBlackFunds(_blackListedUser, dirtyFunds);\n', '    }\n', '\n', '    event DestroyedBlackFunds(address _blackListedUser, uint _balance);\n', '\n', '    event AddedBlackList(address _user);\n', '\n', '    event RemovedBlackList(address _user);\n', '\n', '}\n', '\n', 'contract MexaCoin is Pausable, StandardToken, BlackList {\n', '    \n', '    string public name;\n', '    string public symbol;\n', '    uint public decimals;\n', '    address public upgradedAddress;\n', '    bool public deprecated;\n', '\n', '    // Inicializa el contrato con el suministro inicial de monedas al creador\n', '    //\n', '    // @param _initialSupply    Suministro inicial de monedas\n', '    // @param _name             Establece el nombre de la moneda\n', '    // @param _symbol           Establece el simbolo de la moneda\n', '    // @param _decimals         Establece el numero de decimales\n', '\n', '    constructor (uint _initialSupply, string _name, string _symbol, uint _decimals) public {\n', '        _totalSupply = _initialSupply;\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '        balances[owner] = _initialSupply;\n', '        deprecated = false;\n', '    }\n', '\n', '    // Transferencias entre direcciones\n', '    // Requiere que ni el emisor ni el receptor esten en la lista negra\n', '    // Suspende actividades cuando el contrato se encuentra en pausa\n', '    // Utiliza ERC20.sol para actualizar el contrato si el actual llega a ser obsoleto\n', '    //\n', '    // @param _to               Direccion a la que se envian las monedas\n', '    // @param _value            Cantidad de monedas a enviar\n', '    function transfer(address _to, uint _value) public whenNotPaused {\n', '        require(!isBlackListed[msg.sender]);\n', '        require(!isBlackListed[_to]);\n', '        if (deprecated) {\n', '            return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);\n', '        } else {\n', '            return super.transfer(_to, _value);\n', '        }\n', '    }\n', '\n', '    // Refleja el balance de una direccion\n', '    // Utiliza ERC20.sol para actualizar el contrato si el actual llega a ser obsoleto\n', '    //\n', '    // @param who               Direccion a consultar\n', '    function balanceOf(address who) public constant returns (uint) {\n', '        if (deprecated) {\n', '            return UpgradedStandardToken(upgradedAddress).balanceOf(who);\n', '        } else {\n', '            return super.balanceOf(who);\n', '        }\n', '    }\n', '    \n', '    // Transferencias desde direcciones a nombre de terceros (concesiones)\n', '    // Require que ni el emisor ni el receptor esten en la lista negra\n', '    // Suspende actividades cuando el contrato se encuentra en pausa\n', '    // Utiliza ERC20.sol para actualizar el contrato si el actual llega a ser obsoleto\n', '    //\n', '    // @param _from             Direccion de la que se envian las monedas\n', '    // @param _to               Direccion a la que se envian las monedas\n', '    // @param _value            Cantidad de monedas a enviar\n', '    function transferFrom(address _from, address _to, uint _value) public whenNotPaused {\n', '        require(!isBlackListed[_from]);\n', '        require(!isBlackListed[_to]);\n', '        if (deprecated) {\n', '            return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);\n', '        } else {\n', '            return super.transferFrom(_from, _to, _value);\n', '        }\n', '    }\n', '\n', '    // Permite genera concesiones a direcciones de terceros especificando la direccion y la cantidad de monedas a conceder\n', '    // Require que ni el emisor ni el receptor esten en la lista negra\n', '    // Suspende actividades cuando el contrato se encuentra en pausa\n', '    // Utiliza ERC20.sol para actualizar el contrato si el actual llega a ser obsoleto\n', '    //\n', '    // @param _spender          Direccion a la que se le conceden las monedas\n', '    // @param _value            Cantidad de monedas a conceder\n', '    function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) whenNotPaused {\n', '        require(!isBlackListed[msg.sender]);\n', '        require(!isBlackListed[_spender]);\n', '        if (deprecated) {\n', '            return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);\n', '        } else {\n', '            return super.approve(_spender, _value);\n', '        }\n', '    }\n', '\n', '    // Refleja cantidad de moendas restantes en concesion\n', '    // Utiliza ERC20.sol para actualizar el contrato si el actual llega a ser obsoleto\n', '    //\n', '    // @param _owner            Direccion de quien concede las monedas\n', '    // @param _spender          Direccion que posee la concesion\n', '    function allowance(address _owner, address _spender) public constant returns (uint remaining) {\n', '        if (deprecated) {\n', '            return StandardToken(upgradedAddress).allowance(_owner, _spender);\n', '        } else {\n', '            return super.allowance(_owner, _spender);\n', '        }\n', '    }\n', '\n', '    // Suspende el actual contrato a favor de uno nuevo\n', '    //\n', '    // @param _upgradedAddress  Direccion del nuevo contrato\n', '    function deprecate(address _upgradedAddress) public onlyOwner {\n', '        deprecated = true;\n', '        upgradedAddress = _upgradedAddress;\n', '        emit Deprecate(_upgradedAddress);\n', '    }\n', '\n', '    // Refleja la cantidad total de monedas generada por el contrato\n', '    //\n', '    function totalSupply() public constant returns (uint) {\n', '        if (deprecated) {\n', '            return StandardToken(upgradedAddress).totalSupply();\n', '        } else {\n', '            return _totalSupply;\n', '        }\n', '    }\n', '\n', '    // Genera nuevas monedas y las deposita en la direccion del creador\n', '    //\n', '    // @param _amount           Numero de monedas a generar\n', '    function issue(uint amount) public onlyOwner {\n', '        require(_totalSupply + amount > _totalSupply);\n', '        require(balances[owner] + amount > balances[owner]);\n', '\n', '        balances[owner] += amount;\n', '        _totalSupply += amount;\n', '        emit Issue(amount);\n', '    }\n', '\n', '    // Retiro de monedas\n', '    // Las moendas son retiradas de la cuenta del creador\n', '    // El balance en la cuenta debe ser suficiente para completar la transaccion de lo contrario se generara un error\n', '    // @param _amount           Nuemro de monedas a retirar\n', '    function redeem(uint amount) public onlyOwner {\n', '        require(_totalSupply >= amount);\n', '        require(balances[owner] >= amount);\n', '\n', '        _totalSupply -= amount;\n', '        balances[owner] -= amount;\n', '        emit Redeem(amount);\n', '    }\n', '    \n', '    // Establece el valor de las cuotas en caso de existir\n', '    //\n', '    // @param newBasisPoints    Cuota base\n', '    // @param newMaxFee         Cuota maxima\n', '    function setParams(uint newBasisPoints, uint newMaxFee) public onlyOwner {\n', '        // Asegura el valor maximo que no podran sobrepasar las cuotas\n', '        require(newBasisPoints < 50);\n', '        require(newMaxFee < 1000);\n', '\n', '        basisPointsRate = newBasisPoints;\n', '        maximumFee = newMaxFee.mul(10**decimals);\n', '\n', '        emit Params(basisPointsRate, maximumFee);\n', '    }\n', '    \n', '    // Genera un evento publico en el Blockchain que notificara a los clientes cuando nuevas moendas sean generadas\n', '    event Issue(uint amount);\n', '\n', '    // Genera un evento publico en el Blockchain que notificara a los clientes cuando nuevas moendas sean generadas\n', '    event Redeem(uint amount);\n', '\n', '    // Genera un evento publico en el Blockchain que notificara a los clientes cuando nuevas moendas sean generadas\n', '    event Deprecate(address newAddress);\n', '\n', '    // Genera un evento publico en el Blockchain que notificara a los clientes cuando nuevas moendas sean generadas\n', '    event Params(uint feeBasisPoints, uint maxFee);\n', '}']
['pragma solidity ^0.4.23;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    /**\n', '      * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '      * account.\n', '      */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '      * @dev Throws if called by any account other than the owner.\n', '      */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20Basic {\n', '    uint public _totalSupply;\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address who) public constant returns (uint);\n', '    function transfer(address to, uint value) public;\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is Ownable, ERC20Basic {\n', '    using SafeMath for uint;\n', '\n', '    mapping(address => uint) public balances;\n', '\n', '    // additional variables for use if transaction fees ever became necessary\n', '    uint public basisPointsRate = 0;\n', '    uint public maximumFee = 0;\n', '\n', '    /**\n', '    * @dev Fix for the ERC20 short address attack.\n', '    */\n', '    modifier onlyPayloadSize(uint size) {\n', '        require(!(msg.data.length < size + 4));\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {\n', '        uint fee = (_value.mul(basisPointsRate)).div(10000);\n', '        if (fee > maximumFee) {\n', '            fee = maximumFee;\n', '        }\n', '        uint sendAmount = _value.sub(fee);\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(sendAmount);\n', '        if (fee > 0) {\n', '            balances[owner] = balances[owner].add(fee);\n', '            emit Transfer(msg.sender, owner, fee);\n', '        }\n', '        emit Transfer(msg.sender, _to, sendAmount);\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public constant returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public constant returns (uint);\n', '    function transferFrom(address from, address to, uint value) public;\n', '    function approve(address spender, uint value) public;\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based oncode by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is BasicToken, ERC20 {\n', '\n', '    mapping (address => mapping (address => uint)) public allowed;\n', '\n', '    uint public constant MAX_UINT = 2**256 - 1;\n', '\n', '    /**\n', '    * @dev Transfer tokens from one address to another\n', '    * @param _from address The address which you want to send tokens from\n', '    * @param _to address The address which you want to transfer to\n', '    * @param _value uint the amount of tokens to be transferred\n', '    */\n', '    function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {\n', '        var _allowance = allowed[_from][msg.sender];\n', '\n', '        // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '        // if (_value > _allowance) throw;\n', '\n', '        uint fee = (_value.mul(basisPointsRate)).div(10000);\n', '        if (fee > maximumFee) {\n', '            fee = maximumFee;\n', '        }\n', '        if (_allowance < MAX_UINT) {\n', '            allowed[_from][msg.sender] = _allowance.sub(_value);\n', '        }\n', '        uint sendAmount = _value.sub(fee);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(sendAmount);\n', '        if (fee > 0) {\n', '            balances[owner] = balances[owner].add(fee);\n', '            emit Transfer(_from, owner, fee);\n', '        }\n', '        emit Transfer(_from, _to, sendAmount);\n', '    }\n', '\n', '    /**\n', '    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _value The amount of tokens to be spent.\n', '    */\n', '    function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {\n', '\n', '        // To change the approve amount you first have to reduce the addresses`\n', '        //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '        //  already 0 to mitigate the race condition described here:\n', '        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '    }\n', '\n', '    /**\n', '    * @dev Function to check the amount of tokens than an owner allowed to a spender.\n', '    * @param _owner address The address which owns the funds.\n', '    * @param _spender address The address which will spend the funds.\n', '    * @return A uint specifying the amount of tokens still available for the spender.\n', '    */\n', '    function allowance(address _owner, address _spender) public constant returns (uint remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '}\n', '\n', 'contract UpgradedStandardToken is StandardToken{\n', '    // those methods are called by the legacy contract\n', '    // and they must ensure msg.sender to be the contract address\n', '    function transferByLegacy(address from, address to, uint value) public;\n', '    function transferFromByLegacy(address sender, address from, address spender, uint value) public;\n', '    function approveByLegacy(address from, address spender, uint value) public;\n', '}\n', '\n', 'contract BlackList is Ownable, BasicToken {\n', '\n', '    function getBlackListStatus(address _maker) external constant returns (bool) {\n', '        return isBlackListed[_maker];\n', '    }\n', '\n', '    function getOwner() external constant returns (address) {\n', '        return owner;\n', '    }\n', '\n', '    mapping (address => bool) public isBlackListed;\n', '    \n', '    function addBlackList (address _evilUser) public onlyOwner {\n', '        isBlackListed[_evilUser] = true;\n', '        emit AddedBlackList(_evilUser);\n', '    }\n', '\n', '    function removeBlackList (address _clearedUser) public onlyOwner {\n', '        isBlackListed[_clearedUser] = false;\n', '        emit RemovedBlackList(_clearedUser);\n', '    }\n', '\n', '    function destroyBlackFunds (address _blackListedUser) public onlyOwner {\n', '        require(isBlackListed[_blackListedUser]);\n', '        uint dirtyFunds = balanceOf(_blackListedUser);\n', '        balances[_blackListedUser] = 0;\n', '        //Posible Error\n', '        _totalSupply -= dirtyFunds;\n', '        emit DestroyedBlackFunds(_blackListedUser, dirtyFunds);\n', '    }\n', '\n', '    event DestroyedBlackFunds(address _blackListedUser, uint _balance);\n', '\n', '    event AddedBlackList(address _user);\n', '\n', '    event RemovedBlackList(address _user);\n', '\n', '}\n', '\n', 'contract MexaCoin is Pausable, StandardToken, BlackList {\n', '    \n', '    string public name;\n', '    string public symbol;\n', '    uint public decimals;\n', '    address public upgradedAddress;\n', '    bool public deprecated;\n', '\n', '    // Inicializa el contrato con el suministro inicial de monedas al creador\n', '    //\n', '    // @param _initialSupply    Suministro inicial de monedas\n', '    // @param _name             Establece el nombre de la moneda\n', '    // @param _symbol           Establece el simbolo de la moneda\n', '    // @param _decimals         Establece el numero de decimales\n', '\n', '    constructor (uint _initialSupply, string _name, string _symbol, uint _decimals) public {\n', '        _totalSupply = _initialSupply;\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '        balances[owner] = _initialSupply;\n', '        deprecated = false;\n', '    }\n', '\n', '    // Transferencias entre direcciones\n', '    // Requiere que ni el emisor ni el receptor esten en la lista negra\n', '    // Suspende actividades cuando el contrato se encuentra en pausa\n', '    // Utiliza ERC20.sol para actualizar el contrato si el actual llega a ser obsoleto\n', '    //\n', '    // @param _to               Direccion a la que se envian las monedas\n', '    // @param _value            Cantidad de monedas a enviar\n', '    function transfer(address _to, uint _value) public whenNotPaused {\n', '        require(!isBlackListed[msg.sender]);\n', '        require(!isBlackListed[_to]);\n', '        if (deprecated) {\n', '            return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);\n', '        } else {\n', '            return super.transfer(_to, _value);\n', '        }\n', '    }\n', '\n', '    // Refleja el balance de una direccion\n', '    // Utiliza ERC20.sol para actualizar el contrato si el actual llega a ser obsoleto\n', '    //\n', '    // @param who               Direccion a consultar\n', '    function balanceOf(address who) public constant returns (uint) {\n', '        if (deprecated) {\n', '            return UpgradedStandardToken(upgradedAddress).balanceOf(who);\n', '        } else {\n', '            return super.balanceOf(who);\n', '        }\n', '    }\n', '    \n', '    // Transferencias desde direcciones a nombre de terceros (concesiones)\n', '    // Require que ni el emisor ni el receptor esten en la lista negra\n', '    // Suspende actividades cuando el contrato se encuentra en pausa\n', '    // Utiliza ERC20.sol para actualizar el contrato si el actual llega a ser obsoleto\n', '    //\n', '    // @param _from             Direccion de la que se envian las monedas\n', '    // @param _to               Direccion a la que se envian las monedas\n', '    // @param _value            Cantidad de monedas a enviar\n', '    function transferFrom(address _from, address _to, uint _value) public whenNotPaused {\n', '        require(!isBlackListed[_from]);\n', '        require(!isBlackListed[_to]);\n', '        if (deprecated) {\n', '            return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);\n', '        } else {\n', '            return super.transferFrom(_from, _to, _value);\n', '        }\n', '    }\n', '\n', '    // Permite genera concesiones a direcciones de terceros especificando la direccion y la cantidad de monedas a conceder\n', '    // Require que ni el emisor ni el receptor esten en la lista negra\n', '    // Suspende actividades cuando el contrato se encuentra en pausa\n', '    // Utiliza ERC20.sol para actualizar el contrato si el actual llega a ser obsoleto\n', '    //\n', '    // @param _spender          Direccion a la que se le conceden las monedas\n', '    // @param _value            Cantidad de monedas a conceder\n', '    function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) whenNotPaused {\n', '        require(!isBlackListed[msg.sender]);\n', '        require(!isBlackListed[_spender]);\n', '        if (deprecated) {\n', '            return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);\n', '        } else {\n', '            return super.approve(_spender, _value);\n', '        }\n', '    }\n', '\n', '    // Refleja cantidad de moendas restantes en concesion\n', '    // Utiliza ERC20.sol para actualizar el contrato si el actual llega a ser obsoleto\n', '    //\n', '    // @param _owner            Direccion de quien concede las monedas\n', '    // @param _spender          Direccion que posee la concesion\n', '    function allowance(address _owner, address _spender) public constant returns (uint remaining) {\n', '        if (deprecated) {\n', '            return StandardToken(upgradedAddress).allowance(_owner, _spender);\n', '        } else {\n', '            return super.allowance(_owner, _spender);\n', '        }\n', '    }\n', '\n', '    // Suspende el actual contrato a favor de uno nuevo\n', '    //\n', '    // @param _upgradedAddress  Direccion del nuevo contrato\n', '    function deprecate(address _upgradedAddress) public onlyOwner {\n', '        deprecated = true;\n', '        upgradedAddress = _upgradedAddress;\n', '        emit Deprecate(_upgradedAddress);\n', '    }\n', '\n', '    // Refleja la cantidad total de monedas generada por el contrato\n', '    //\n', '    function totalSupply() public constant returns (uint) {\n', '        if (deprecated) {\n', '            return StandardToken(upgradedAddress).totalSupply();\n', '        } else {\n', '            return _totalSupply;\n', '        }\n', '    }\n', '\n', '    // Genera nuevas monedas y las deposita en la direccion del creador\n', '    //\n', '    // @param _amount           Numero de monedas a generar\n', '    function issue(uint amount) public onlyOwner {\n', '        require(_totalSupply + amount > _totalSupply);\n', '        require(balances[owner] + amount > balances[owner]);\n', '\n', '        balances[owner] += amount;\n', '        _totalSupply += amount;\n', '        emit Issue(amount);\n', '    }\n', '\n', '    // Retiro de monedas\n', '    // Las moendas son retiradas de la cuenta del creador\n', '    // El balance en la cuenta debe ser suficiente para completar la transaccion de lo contrario se generara un error\n', '    // @param _amount           Nuemro de monedas a retirar\n', '    function redeem(uint amount) public onlyOwner {\n', '        require(_totalSupply >= amount);\n', '        require(balances[owner] >= amount);\n', '\n', '        _totalSupply -= amount;\n', '        balances[owner] -= amount;\n', '        emit Redeem(amount);\n', '    }\n', '    \n', '    // Establece el valor de las cuotas en caso de existir\n', '    //\n', '    // @param newBasisPoints    Cuota base\n', '    // @param newMaxFee         Cuota maxima\n', '    function setParams(uint newBasisPoints, uint newMaxFee) public onlyOwner {\n', '        // Asegura el valor maximo que no podran sobrepasar las cuotas\n', '        require(newBasisPoints < 50);\n', '        require(newMaxFee < 1000);\n', '\n', '        basisPointsRate = newBasisPoints;\n', '        maximumFee = newMaxFee.mul(10**decimals);\n', '\n', '        emit Params(basisPointsRate, maximumFee);\n', '    }\n', '    \n', '    // Genera un evento publico en el Blockchain que notificara a los clientes cuando nuevas moendas sean generadas\n', '    event Issue(uint amount);\n', '\n', '    // Genera un evento publico en el Blockchain que notificara a los clientes cuando nuevas moendas sean generadas\n', '    event Redeem(uint amount);\n', '\n', '    // Genera un evento publico en el Blockchain que notificara a los clientes cuando nuevas moendas sean generadas\n', '    event Deprecate(address newAddress);\n', '\n', '    // Genera un evento publico en el Blockchain que notificara a los clientes cuando nuevas moendas sean generadas\n', '    event Params(uint feeBasisPoints, uint maxFee);\n', '}']
