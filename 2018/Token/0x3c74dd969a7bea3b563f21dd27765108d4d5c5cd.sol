['pragma solidity ^0.4.24;\n', '\n', 'library SafeMath {\n', '\n', '    function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '        if (_a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        c = _a * _b;\n', '        assert(c / _a == _b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '        return _a / _b;\n', '    }\n', '\n', '    function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '        assert(_b <= _a);\n', '        return _a - _b;\n', '    }\n', '\n', '    function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '        c = _a + _b;\n', '        assert(c >= _a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', '\n', 'contract BaseCHIPToken {\n', '    using SafeMath for uint256;\n', '\n', '    // Globals\n', '    address public owner;\n', '    mapping(address => uint256) internal balances;\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '    uint256 internal totalSupply_;\n', '\n', '    // Events\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Burn(address indexed burner, uint256 value);\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '    event Mint(address indexed to, uint256 amount);\n', '\n', '    // Modifiers\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner,"Only the owner is allowed to call this."); \n', '        _; \n', '    }\n', '\n', '    constructor() public{\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '    * @dev Total number of tokens in existence\n', '    */\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_value <= balances[msg.sender], "You do not have sufficient balance.");\n', '        require(_to != address(0), "You cannot send tokens to 0 address");\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public view returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer tokens from one address to another\n', '    * @param _from address The address which you want to send tokens from\n', '    * @param _to address The address which you want to transfer to\n', '    * @param _value uint256 the amount of tokens to be transferred\n', '    */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool){\n', '        require(_value <= balances[_from], "You do not have sufficient balance.");\n', '        require(_value <= allowed[_from][msg.sender], "You do not have allowance.");\n', '        require(_to != address(0), "You cannot send tokens to 0 address");\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '    * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '    * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _value The amount of tokens to be spent.\n', '    */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '    * @param _owner address The address which owns the funds.\n', '    * @param _spender address The address which will spend the funds.\n', '    * @return A uint256 specifying the amount of tokens still available for the spender.\n', '    */\n', '    function allowance(address _owner, address _spender) public view returns (uint256){\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '    * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '    * approve should be called when allowed[_spender] == 0. To increment\n', '    * allowed value is better to use this function to avoid 2 calls (and wait until\n', '    * the first transaction is mined)\n', '    * From MonolithDAO Token.sol\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _addedValue The amount of tokens to increase the allowance by.\n', '    */\n', '    function increaseApproval(address _spender, uint256 _addedValue) public returns (bool){\n', '        allowed[msg.sender][_spender] = (\n', '        allowed[msg.sender][_spender].add(_addedValue));\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '    * approve should be called when allowed[_spender] == 0. To decrement\n', '    * allowed value is better to use this function to avoid 2 calls (and wait until\n', '    * the first transaction is mined)\n', '    * From MonolithDAO Token.sol\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '    */\n', '    function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool){\n', '        uint256 oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue >= oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Burns a specific amount of tokens.\n', '    * @param _value The amount of token to be burned.\n', '    */\n', '    function burn(uint256 _value) public {\n', '        _burn(msg.sender, _value);\n', '    }\n', '\n', '    function _burn(address _who, uint256 _value) internal {\n', '        require(_value <= balances[_who], "Insufficient balance of tokens");\n', '        // no need to require value <= totalSupply, since that would imply the\n', '        // sender&#39;s balance is greater than the totalSupply, which *should* be an assertion failure\n', '\n', '        balances[_who] = balances[_who].sub(_value);\n', '        totalSupply_ = totalSupply_.sub(_value);\n', '        emit Burn(_who, _value);\n', '        emit Transfer(_who, address(0), _value);\n', '    }\n', '\n', '    /**\n', '    * @dev Burns a specific amount of tokens from the target address and decrements allowance\n', '    * @param _from address The address which you want to send tokens from\n', '    * @param _value uint256 The amount of token to be burned\n', '    */\n', '    function burnFrom(address _from, uint256 _value) public {\n', '        require(_value <= allowed[_from][msg.sender], "Insufficient allowance to burn tokens.");\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        _burn(_from, _value);\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param _newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        _transferOwnership(_newOwner);\n', '    }\n', '\n', '    /**\n', '    * @dev Transfers control of the contract to a newOwner.\n', '    * @param _newOwner The address to transfer ownership to.\n', '    */\n', '    function _transferOwnership(address _newOwner) internal {\n', '        require(_newOwner != address(0), "Owner cannot be 0 address.");\n', '        emit OwnershipTransferred(owner, _newOwner);\n', '        owner = _newOwner;\n', '    }\n', '\n', '    /**\n', '    * @dev Function to mint tokens\n', '    * @param _to The address that will receive the minted tokens.\n', '    * @param _amount The amount of tokens to mint.\n', '    * @return A boolean that indicates if the operation was successful.\n', '    */\n', '    function mint(address _to, uint256 _amount) public onlyOwner returns (bool){\n', '        totalSupply_ = totalSupply_.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Mint(_to, _amount);\n', '        emit Transfer(address(0), _to, _amount);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', 'contract CHIPToken is BaseCHIPToken {\n', '    \n', '    // Constants\n', '    string  public constant name = "Chips";\n', '    string  public constant symbol = "CHP";\n', '    uint8   public constant decimals = 18;\n', '\n', '    uint256 public constant INITIAL_SUPPLY      =  2000000000 * (10 ** uint256(decimals));\n', '    uint256 public constant CROWDSALE_ALLOWANCE =  1000000000 * (10 ** uint256(decimals));\n', '    uint256 public constant ADMIN_ALLOWANCE     =  1000000000 * (10 ** uint256(decimals));\n', '    \n', '    // Properties\n', '    //uint256 public totalSupply;\n', '    uint256 public crowdSaleAllowance;      // the number of tokens available for crowdsales\n', '    uint256 public adminAllowance;          // the number of tokens available for the administrator\n', '    address public crowdSaleAddr;           // the address of a crowdsale currently selling this token\n', '    address public adminAddr;               // the address of a crowdsale currently selling this token\n', '    //bool    public transferEnabled = false; // indicates if transferring tokens is enabled or not\n', '    bool    public transferEnabled = true;  // Enables everyone to transfer tokens\n', '\n', '    /**\n', '     * The listed addresses are not valid recipients of tokens.\n', '     *\n', '     * 0x0           - the zero address is not valid\n', '     * this          - the contract itself should not receive tokens\n', '     * owner         - the owner has all the initial tokens, but cannot receive any back\n', '     * adminAddr     - the admin has an allowance of tokens to transfer, but does not receive any\n', '     * crowdSaleAddr - the crowdsale has an allowance of tokens to transfer, but does not receive any\n', '     */\n', '    modifier validDestination(address _to) {\n', '        require(_to != address(0x0), "Cannot send to 0 address");\n', '        require(_to != address(this), "Cannot send to contract address");\n', '        //require(_to != owner, "Cannot send to the owner");\n', '        //require(_to != address(adminAddr), "Cannot send to admin address");\n', '        require(_to != address(crowdSaleAddr), "Cannot send to crowdsale address");\n', '        _;\n', '    }\n', '\n', '    modifier onlyCrowdsale {\n', '        require(msg.sender == crowdSaleAddr, "Only crowdsale contract can call this");\n', '        _;\n', '    }\n', '\n', '    constructor(address _admin) public {\n', '        require(msg.sender != _admin, "Owner and admin cannot be the same");\n', '\n', '        totalSupply_ = INITIAL_SUPPLY;\n', '        crowdSaleAllowance = CROWDSALE_ALLOWANCE;\n', '        adminAllowance = ADMIN_ALLOWANCE;\n', '\n', '        // mint all tokens\n', '        balances[msg.sender] = totalSupply_.sub(adminAllowance);\n', '        emit Transfer(address(0x0), msg.sender, totalSupply_.sub(adminAllowance));\n', '\n', '        balances[_admin] = adminAllowance;\n', '        emit Transfer(address(0x0), _admin, adminAllowance);\n', '\n', '        adminAddr = _admin;\n', '        approve(adminAddr, adminAllowance);\n', '    }\n', '\n', '    /**\n', '     * Overrides ERC20 transfer function with modifier that prevents the\n', '     * ability to transfer tokens until after transfers have been enabled.\n', '     */\n', '    function transfer(address _to, uint256 _value) public validDestination(_to) returns (bool) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    /**\n', '     * Overrides ERC20 transferFrom function with modifier that prevents the\n', '     * ability to transfer tokens until after transfers have been enabled.\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public validDestination(_to) returns (bool) {\n', '        bool result = super.transferFrom(_from, _to, _value);\n', '        if (result) {\n', '            if (msg.sender == crowdSaleAddr)\n', '                crowdSaleAllowance = crowdSaleAllowance.sub(_value);\n', '            if (msg.sender == adminAddr)\n', '                adminAllowance = adminAllowance.sub(_value);\n', '        }\n', '        return result;\n', '    }\n', '\n', '    /**\n', '     * Associates this token with a current crowdsale, giving the crowdsale\n', '     * an allowance of tokens from the crowdsale supply. This gives the\n', '     * crowdsale the ability to call transferFrom to transfer tokens to\n', '     * whomever has purchased them.\n', '     *\n', '     * Note that if _amountForSale is 0, then it is assumed that the full\n', '     * remaining crowdsale supply is made available to the crowdsale.\n', '     *\n', '     * @param _crowdSaleAddr The address of a crowdsale contract that will sell this token\n', '     * @param _amountForSale The supply of tokens provided to the crowdsale\n', '     */\n', '    function setCrowdsale(address _crowdSaleAddr, uint256 _amountForSale) external onlyOwner {\n', '        require(_amountForSale <= crowdSaleAllowance, "Sale amount should be less than the crowdsale allowance limits.");\n', '\n', '        // if 0, then full available crowdsale supply is assumed\n', '        uint amount = (_amountForSale == 0) ? crowdSaleAllowance : _amountForSale;\n', '\n', '        // Clear allowance of old, and set allowance of new\n', '        approve(crowdSaleAddr, 0);\n', '        approve(_crowdSaleAddr, amount);\n', '\n', '        crowdSaleAddr = _crowdSaleAddr;\n', '    }\n', '\n', '    function setAllowanceBeforeWithdrawal(address _from, address _to, uint _value) public onlyCrowdsale returns (bool) {\n', '        allowed[_from][_to] = _value;\n', '        emit Approval(_from, _to, _value);\n', '        return true;\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', 'library SafeMath {\n', '\n', '    function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '        if (_a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        c = _a * _b;\n', '        assert(c / _a == _b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '        return _a / _b;\n', '    }\n', '\n', '    function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '        assert(_b <= _a);\n', '        return _a - _b;\n', '    }\n', '\n', '    function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '        c = _a + _b;\n', '        assert(c >= _a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', '\n', 'contract BaseCHIPToken {\n', '    using SafeMath for uint256;\n', '\n', '    // Globals\n', '    address public owner;\n', '    mapping(address => uint256) internal balances;\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '    uint256 internal totalSupply_;\n', '\n', '    // Events\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Burn(address indexed burner, uint256 value);\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '    event Mint(address indexed to, uint256 amount);\n', '\n', '    // Modifiers\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner,"Only the owner is allowed to call this."); \n', '        _; \n', '    }\n', '\n', '    constructor() public{\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '    * @dev Total number of tokens in existence\n', '    */\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_value <= balances[msg.sender], "You do not have sufficient balance.");\n', '        require(_to != address(0), "You cannot send tokens to 0 address");\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public view returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer tokens from one address to another\n', '    * @param _from address The address which you want to send tokens from\n', '    * @param _to address The address which you want to transfer to\n', '    * @param _value uint256 the amount of tokens to be transferred\n', '    */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool){\n', '        require(_value <= balances[_from], "You do not have sufficient balance.");\n', '        require(_value <= allowed[_from][msg.sender], "You do not have allowance.");\n', '        require(_to != address(0), "You cannot send tokens to 0 address");\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '    * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _value The amount of tokens to be spent.\n', '    */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '    * @param _owner address The address which owns the funds.\n', '    * @param _spender address The address which will spend the funds.\n', '    * @return A uint256 specifying the amount of tokens still available for the spender.\n', '    */\n', '    function allowance(address _owner, address _spender) public view returns (uint256){\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '    * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '    * approve should be called when allowed[_spender] == 0. To increment\n', '    * allowed value is better to use this function to avoid 2 calls (and wait until\n', '    * the first transaction is mined)\n', '    * From MonolithDAO Token.sol\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _addedValue The amount of tokens to increase the allowance by.\n', '    */\n', '    function increaseApproval(address _spender, uint256 _addedValue) public returns (bool){\n', '        allowed[msg.sender][_spender] = (\n', '        allowed[msg.sender][_spender].add(_addedValue));\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '    * approve should be called when allowed[_spender] == 0. To decrement\n', '    * allowed value is better to use this function to avoid 2 calls (and wait until\n', '    * the first transaction is mined)\n', '    * From MonolithDAO Token.sol\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '    */\n', '    function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool){\n', '        uint256 oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue >= oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Burns a specific amount of tokens.\n', '    * @param _value The amount of token to be burned.\n', '    */\n', '    function burn(uint256 _value) public {\n', '        _burn(msg.sender, _value);\n', '    }\n', '\n', '    function _burn(address _who, uint256 _value) internal {\n', '        require(_value <= balances[_who], "Insufficient balance of tokens");\n', '        // no need to require value <= totalSupply, since that would imply the\n', "        // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '\n', '        balances[_who] = balances[_who].sub(_value);\n', '        totalSupply_ = totalSupply_.sub(_value);\n', '        emit Burn(_who, _value);\n', '        emit Transfer(_who, address(0), _value);\n', '    }\n', '\n', '    /**\n', '    * @dev Burns a specific amount of tokens from the target address and decrements allowance\n', '    * @param _from address The address which you want to send tokens from\n', '    * @param _value uint256 The amount of token to be burned\n', '    */\n', '    function burnFrom(address _from, uint256 _value) public {\n', '        require(_value <= allowed[_from][msg.sender], "Insufficient allowance to burn tokens.");\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        _burn(_from, _value);\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param _newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        _transferOwnership(_newOwner);\n', '    }\n', '\n', '    /**\n', '    * @dev Transfers control of the contract to a newOwner.\n', '    * @param _newOwner The address to transfer ownership to.\n', '    */\n', '    function _transferOwnership(address _newOwner) internal {\n', '        require(_newOwner != address(0), "Owner cannot be 0 address.");\n', '        emit OwnershipTransferred(owner, _newOwner);\n', '        owner = _newOwner;\n', '    }\n', '\n', '    /**\n', '    * @dev Function to mint tokens\n', '    * @param _to The address that will receive the minted tokens.\n', '    * @param _amount The amount of tokens to mint.\n', '    * @return A boolean that indicates if the operation was successful.\n', '    */\n', '    function mint(address _to, uint256 _amount) public onlyOwner returns (bool){\n', '        totalSupply_ = totalSupply_.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Mint(_to, _amount);\n', '        emit Transfer(address(0), _to, _amount);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', 'contract CHIPToken is BaseCHIPToken {\n', '    \n', '    // Constants\n', '    string  public constant name = "Chips";\n', '    string  public constant symbol = "CHP";\n', '    uint8   public constant decimals = 18;\n', '\n', '    uint256 public constant INITIAL_SUPPLY      =  2000000000 * (10 ** uint256(decimals));\n', '    uint256 public constant CROWDSALE_ALLOWANCE =  1000000000 * (10 ** uint256(decimals));\n', '    uint256 public constant ADMIN_ALLOWANCE     =  1000000000 * (10 ** uint256(decimals));\n', '    \n', '    // Properties\n', '    //uint256 public totalSupply;\n', '    uint256 public crowdSaleAllowance;      // the number of tokens available for crowdsales\n', '    uint256 public adminAllowance;          // the number of tokens available for the administrator\n', '    address public crowdSaleAddr;           // the address of a crowdsale currently selling this token\n', '    address public adminAddr;               // the address of a crowdsale currently selling this token\n', '    //bool    public transferEnabled = false; // indicates if transferring tokens is enabled or not\n', '    bool    public transferEnabled = true;  // Enables everyone to transfer tokens\n', '\n', '    /**\n', '     * The listed addresses are not valid recipients of tokens.\n', '     *\n', '     * 0x0           - the zero address is not valid\n', '     * this          - the contract itself should not receive tokens\n', '     * owner         - the owner has all the initial tokens, but cannot receive any back\n', '     * adminAddr     - the admin has an allowance of tokens to transfer, but does not receive any\n', '     * crowdSaleAddr - the crowdsale has an allowance of tokens to transfer, but does not receive any\n', '     */\n', '    modifier validDestination(address _to) {\n', '        require(_to != address(0x0), "Cannot send to 0 address");\n', '        require(_to != address(this), "Cannot send to contract address");\n', '        //require(_to != owner, "Cannot send to the owner");\n', '        //require(_to != address(adminAddr), "Cannot send to admin address");\n', '        require(_to != address(crowdSaleAddr), "Cannot send to crowdsale address");\n', '        _;\n', '    }\n', '\n', '    modifier onlyCrowdsale {\n', '        require(msg.sender == crowdSaleAddr, "Only crowdsale contract can call this");\n', '        _;\n', '    }\n', '\n', '    constructor(address _admin) public {\n', '        require(msg.sender != _admin, "Owner and admin cannot be the same");\n', '\n', '        totalSupply_ = INITIAL_SUPPLY;\n', '        crowdSaleAllowance = CROWDSALE_ALLOWANCE;\n', '        adminAllowance = ADMIN_ALLOWANCE;\n', '\n', '        // mint all tokens\n', '        balances[msg.sender] = totalSupply_.sub(adminAllowance);\n', '        emit Transfer(address(0x0), msg.sender, totalSupply_.sub(adminAllowance));\n', '\n', '        balances[_admin] = adminAllowance;\n', '        emit Transfer(address(0x0), _admin, adminAllowance);\n', '\n', '        adminAddr = _admin;\n', '        approve(adminAddr, adminAllowance);\n', '    }\n', '\n', '    /**\n', '     * Overrides ERC20 transfer function with modifier that prevents the\n', '     * ability to transfer tokens until after transfers have been enabled.\n', '     */\n', '    function transfer(address _to, uint256 _value) public validDestination(_to) returns (bool) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    /**\n', '     * Overrides ERC20 transferFrom function with modifier that prevents the\n', '     * ability to transfer tokens until after transfers have been enabled.\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public validDestination(_to) returns (bool) {\n', '        bool result = super.transferFrom(_from, _to, _value);\n', '        if (result) {\n', '            if (msg.sender == crowdSaleAddr)\n', '                crowdSaleAllowance = crowdSaleAllowance.sub(_value);\n', '            if (msg.sender == adminAddr)\n', '                adminAllowance = adminAllowance.sub(_value);\n', '        }\n', '        return result;\n', '    }\n', '\n', '    /**\n', '     * Associates this token with a current crowdsale, giving the crowdsale\n', '     * an allowance of tokens from the crowdsale supply. This gives the\n', '     * crowdsale the ability to call transferFrom to transfer tokens to\n', '     * whomever has purchased them.\n', '     *\n', '     * Note that if _amountForSale is 0, then it is assumed that the full\n', '     * remaining crowdsale supply is made available to the crowdsale.\n', '     *\n', '     * @param _crowdSaleAddr The address of a crowdsale contract that will sell this token\n', '     * @param _amountForSale The supply of tokens provided to the crowdsale\n', '     */\n', '    function setCrowdsale(address _crowdSaleAddr, uint256 _amountForSale) external onlyOwner {\n', '        require(_amountForSale <= crowdSaleAllowance, "Sale amount should be less than the crowdsale allowance limits.");\n', '\n', '        // if 0, then full available crowdsale supply is assumed\n', '        uint amount = (_amountForSale == 0) ? crowdSaleAllowance : _amountForSale;\n', '\n', '        // Clear allowance of old, and set allowance of new\n', '        approve(crowdSaleAddr, 0);\n', '        approve(_crowdSaleAddr, amount);\n', '\n', '        crowdSaleAddr = _crowdSaleAddr;\n', '    }\n', '\n', '    function setAllowanceBeforeWithdrawal(address _from, address _to, uint _value) public onlyCrowdsale returns (bool) {\n', '        allowed[_from][_to] = _value;\n', '        emit Approval(_from, _to, _value);\n', '        return true;\n', '    }\n', '}']
