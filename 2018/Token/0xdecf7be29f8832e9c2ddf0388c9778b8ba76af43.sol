['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @dev Library that helps prevent integer overflows and underflows,\n', ' * inspired by https://github.com/OpenZeppelin/zeppelin-solidity\n', ' */\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', '\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title HasOwner\n', ' *\n', ' * @dev Allows for exclusive access to certain functionality.\n', ' */\n', 'contract HasOwner {\n', '    // Current owner.\n', '    address public owner;\n', '\n', '    // Conditionally the new owner.\n', '    address public newOwner;\n', '\n', '    /**\n', '     * @dev The constructor.\n', '     *\n', '     * @param _owner The address of the owner.\n', '     */\n', '    constructor(address _owner) internal {\n', '        owner = _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Access control modifier that allows only the current owner to call the function.\n', '     */\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev The event is fired when the current owner is changed.\n', '     *\n', '     * @param _oldOwner The address of the previous owner.\n', '     * @param _newOwner The address of the new owner.\n', '     */\n', '    event OwnershipTransfer(address indexed _oldOwner, address indexed _newOwner);\n', '\n', '    /**\n', '     * @dev Transfering the ownership is a two-step process, as we prepare\n', '     * for the transfer by setting `newOwner` and requiring `newOwner` to accept\n', '     * the transfer. This prevents accidental lock-out if something goes wrong\n', '     * when passing the `newOwner` address.\n', '     *\n', '     * @param _newOwner The address of the proposed new owner.\n', '     */\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    /**\n', '     * @dev The `newOwner` finishes the ownership transfer process by accepting the\n', '     * ownership.\n', '     */\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '\n', '        emit OwnershipTransfer(owner, newOwner);\n', '\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '/**\n', ' * @dev The standard ERC20 Token interface.\n', ' */\n', 'contract ERC20TokenInterface {\n', '    uint256 public totalSupply;  /* shorthand for public function and a property */\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '}\n', '\n', '/**\n', ' * @title ERC20Token\n', ' *\n', ' * @dev Implements the operations declared in the `ERC20TokenInterface`.\n', ' */\n', 'contract ERC20Token is ERC20TokenInterface {\n', '    using SafeMath for uint256;\n', '\n', '    // Token account balances.\n', '    mapping (address => uint256) balances;\n', '\n', '    // Delegated number of tokens to transfer.\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    /**\n', '     * @dev Checks the balance of a certain address.\n', '     *\n', "     * @param _account The address which's balance will be checked.\n", '     *\n', '     * @return Returns the balance of the `_account` address.\n', '     */\n', '    function balanceOf(address _account) public constant returns (uint256 balance) {\n', '        return balances[_account];\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers tokens from one address to another.\n', '     *\n', '     * @param _to The target address to which the `_value` number of tokens will be sent.\n', '     * @param _value The number of tokens to send.\n', '     *\n', '     * @return Whether the transfer was successful or not.\n', '     */\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '        require(_value > 0);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        emit Transfer(msg.sender, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Send `_value` tokens to `_to` from `_from` if `_from` has approved the process.\n', '     *\n', '     * @param _from The address of the sender.\n', '     * @param _to The address of the recipient.\n', '     * @param _value The number of tokens to be transferred.\n', '     *\n', '     * @return Whether the transfer was successful or not.\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        require(_value > 0);\n', '        require(_to != address(0));\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '\n', '        emit Transfer(_from, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows another contract to spend some tokens on your behalf.\n', '     *\n', '     * @param _spender The address of the account which will be approved for transfer of tokens.\n', '     * @param _value The number of tokens to be approved for transfer.\n', '     *\n', '     * @return Whether the approval was successful or not.\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '\n', '        emit Approval(msg.sender, _spender, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '\t/**\n', '\t * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '\t * approve should be called when allowed[_spender] == 0. To increment\n', '\t * allowed value is better to use this function to avoid 2 calls (and wait until\n', '\t * the first transaction is mined)\n', '\t * From MonolithDAO Token.sol\n', '\t *\n', '\t * @param _spender The address which will spend the funds.\n', '\t * @param _addedValue The amount of tokens to increase the allowance by.\n', '\t */\n', '\tfunction increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {\n', '\t\tallowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));\n', '\n', '\t\temit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\n', '\t\treturn true;\n', '\t}\n', '\n', '\t/**\n', '\t * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '\t * approve should be called when allowed[_spender] == 0. To decrement\n', '\t * allowed value is better to use this function to avoid 2 calls (and wait until\n', '\t * the first transaction is mined)\n', '\t * From MonolithDAO Token.sol\n', '\t *\n', '\t * @param _spender The address which will spend the funds.\n', '\t * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '\t */\n', '\tfunction decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {\n', '\t\tuint256 oldValue = allowed[msg.sender][_spender];\n', '\t\tif (_subtractedValue >= oldValue) {\n', '\t\t\tallowed[msg.sender][_spender] = 0;\n', '\t\t} else {\n', '\t\t\tallowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '\t\t}\n', '\n', '\t\temit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\t\treturn true;\n', '\t}\n', '\n', '    /**\n', '     * @dev Shows the number of tokens approved by `_owner` that are allowed to be transferred by `_spender`.\n', '     *\n', '     * @param _owner The account which allowed the transfer.\n', '     * @param _spender The account which will spend the tokens.\n', '     *\n', '     * @return The number of tokens to be transferred.\n', '     */\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', "     * Don't accept ETH\n", '     */\n', '    function () public payable {\n', '        revert();\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Freezable\n', ' * @dev This trait allows to freeze the transactions in a Token\n', ' */\n', 'contract Freezable is HasOwner {\n', '    bool public frozen = false;\n', '\n', '    /**\n', '     * @dev Modifier makes methods callable only when the contract is not frozen.\n', '     */\n', '    modifier requireNotFrozen() {\n', '        require(!frozen);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the owner to "freeze" the contract.\n', '     */\n', '    function freeze() onlyOwner public {\n', '        frozen = true;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the owner to "unfreeze" the contract.\n', '     */\n', '    function unfreeze() onlyOwner public {\n', '        frozen = false;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title FreezableERC20Token\n', ' *\n', ' * @dev Extends ERC20Token and adds ability to freeze all transfers of tokens.\n', ' */\n', 'contract FreezableERC20Token is ERC20Token, Freezable {\n', '    /**\n', '     * @dev Overrides the original ERC20Token implementation by adding whenNotFrozen modifier.\n', '     *\n', '     * @param _to The target address to which the `_value` number of tokens will be sent.\n', '     * @param _value The number of tokens to send.\n', '     *\n', '     * @return Whether the transfer was successful or not.\n', '     */\n', '    function transfer(address _to, uint _value) public requireNotFrozen returns (bool success) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    /**\n', '     * @dev Send `_value` tokens to `_to` from `_from` if `_from` has approved the process.\n', '     *\n', '     * @param _from The address of the sender.\n', '     * @param _to The address of the recipient.\n', '     * @param _value The number of tokens to be transferred.\n', '     *\n', '     * @return Whether the transfer was successful or not.\n', '     */\n', '    function transferFrom(address _from, address _to, uint _value) public requireNotFrozen returns (bool success) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * @dev Allows another contract to spend some tokens on your behalf.\n', '     *\n', '     * @param _spender The address of the account which will be approved for transfer of tokens.\n', '     * @param _value The number of tokens to be approved for transfer.\n', '     *\n', '     * @return Whether the approval was successful or not.\n', '     */\n', '    function approve(address _spender, uint _value) public requireNotFrozen returns (bool success) {\n', '        return super.approve(_spender, _value);\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint256 _addedValue) public requireNotFrozen returns (bool) {\n', '        return super.increaseApproval(_spender, _addedValue);\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint256 _subtractedValue) public requireNotFrozen returns (bool) {\n', '        return super.decreaseApproval(_spender, _subtractedValue);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title BonusCloudTokenConfig\n', ' *\n', ' * @dev The static configuration for the Bonus Cloud Token.\n', ' */\n', 'contract BonusCloudTokenConfig {\n', '    // The name of the token.\n', '    string constant NAME = "BonusCloud Token";\n', '\n', '    // The symbol of the token.\n', '    string constant SYMBOL = "BxC";\n', '\n', '    // The number of decimals for the token.\n', '    uint8 constant DECIMALS = 18;\n', '\n', '    // Decimal factor for multiplication purposes.\n', '    uint256 constant DECIMALS_FACTOR = 10 ** uint(DECIMALS);\n', '\n', '    // TotalSupply\n', '    uint256 constant TOTAL_SUPPLY = 7000000000 * DECIMALS_FACTOR;\n', '}\n', '\n', '/**\n', ' * @title Bonus Cloud Token\n', ' *\n', ' * @dev A standard token implementation of the ERC20 token standard with added\n', ' *      HasOwner trait and initialized using the configuration constants.\n', ' */\n', 'contract BonusCloudToken is BonusCloudTokenConfig, HasOwner, FreezableERC20Token {\n', '    // The name of the token.\n', '    string public name;\n', '\n', '    // The symbol for the token.\n', '    string public symbol;\n', '\n', '    // The decimals of the token.\n', '    uint8 public decimals;\n', '\n', '    /**\n', '     * @dev The constructor.\n', '     *\n', '     */\n', '    constructor() public HasOwner(msg.sender) {\n', '        name = NAME;\n', '        symbol = SYMBOL;\n', '        decimals = DECIMALS;\n', '        totalSupply = TOTAL_SUPPLY;\n', '        balances[owner] = TOTAL_SUPPLY;\n', '    }\n', '}']