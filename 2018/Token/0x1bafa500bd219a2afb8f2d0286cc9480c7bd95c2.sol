['pragma solidity ^0.4.18;\n', '/**\n', '* TOKEN Contract\n', '* ERC-20 Token Standard Compliant\n', '* @author Fares A. Akel C. f.antonio.akel@gmail.com\n', '*/\n', '\n', '/**\n', ' * @title SafeMath by OpenZeppelin\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * Token contract interface for external use\n', ' */\n', 'contract ERC20TokenInterface {\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 value);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '\n', '    }\n', '\n', 'contract ApproveAndCallFallBack {\n', ' \n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', ' \n', '}\n', '\n', '/**\n', '* @title Admin parameters\n', '* @dev Define administration parameters for this contract\n', '*/\n', 'contract admined { //This token contract is administered\n', '    address public admin; //Admin address is public\n', '    bool public lockSupply; //Mint and Burn Lock flag\n', '    bool public lockTransfer; //Transfer Lock flag\n', '    address public allowedAddress; //an address that can override lock condition\n', '\n', '    /**\n', '    * @dev Contract constructor\n', '    * define initial administrator\n', '    */\n', '    function admined() internal {\n', '        admin = msg.sender; //Set initial admin to contract creator\n', '        Admined(admin);\n', '    }\n', '\n', '   /**\n', '    * @dev Function to set an allowed address\n', '    * @param _to The address to give privileges.\n', '    */\n', '    function setAllowedAddress(address _to) onlyAdmin public {\n', '        allowedAddress = _to;\n', '        AllowedSet(_to);\n', '    }\n', '\n', '    modifier onlyAdmin() { //A modifier to define admin-only functions\n', '        require(msg.sender == admin);\n', '        _;\n', '    }\n', '\n', '    modifier supplyLock() { //A modifier to lock mint and burn transactions\n', '        require(lockSupply == false);\n', '        _;\n', '    }\n', '\n', '    modifier transferLock() { //A modifier to lock transactions\n', '        require(lockTransfer == false || allowedAddress == msg.sender);\n', '        _;\n', '    }\n', '\n', '   /**\n', '    * @dev Function to set new admin address\n', '    * @param _newAdmin The address to transfer administration to\n', '    */\n', '    function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered\n', '        require(_newAdmin != 0);\n', '        admin = _newAdmin;\n', '        TransferAdminship(admin);\n', '    }\n', '\n', '   /**\n', '    * @dev Function to set mint and burn locks\n', '    * @param _set boolean flag (true | false)\n', '    */\n', '    function setSupplyLock(bool _set) onlyAdmin public { //Only the admin can set a lock on supply\n', '        lockSupply = _set;\n', '        SetSupplyLock(_set);\n', '    }\n', '\n', '   /**\n', '    * @dev Function to set transfer lock\n', '    * @param _set boolean flag (true | false)\n', '    */\n', '    function setTransferLock(bool _set) onlyAdmin public { //Only the admin can set a lock on transfers\n', '        lockTransfer = _set;\n', '        SetTransferLock(_set);\n', '    }\n', '\n', '    //All admin actions have a log for public review\n', '    event AllowedSet(address _to);\n', '    event SetSupplyLock(bool _set);\n', '    event SetTransferLock(bool _set);\n', '    event TransferAdminship(address newAdminister);\n', '    event Admined(address administer);\n', '\n', '}\n', '\n', '/**\n', '* @title Token definition\n', '* @dev Define token paramters including ERC20 ones\n', '*/\n', 'contract ERC20Token is ERC20TokenInterface, admined { //Standard definition of a ERC20Token\n', '    using SafeMath for uint256;\n', '    uint256 public totalSupply;\n', '    mapping (address => uint256) balances; //A mapping of all balances per address\n', '    mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances\n', '    mapping (address => bool) frozen; //A mapping of frozen accounts\n', '\n', '    /**\n', '    * @dev Get the balance of an specified address.\n', '    * @param _owner The address to be query.\n', '    */\n', '    function balanceOf(address _owner) public constant returns (uint256 value) {\n', '      return balances[_owner];\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token to a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) transferLock public returns (bool success) {\n', '        require(_to != address(0)); //If you dont want that people destroy token\n', '        require(frozen[msg.sender]==false);\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token from an address to another specified address using allowance\n', '    * @param _from The address where token comes.\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transferFrom(address _from, address _to, uint256 _value) transferLock public returns (bool success) {\n', '        require(_to != address(0)); //If you dont want that people destroy token\n', '        require(frozen[_from]==false);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Assign allowance to an specified address to use the owner balance\n', '    * @param _spender The address to be allowed to spend.\n', '    * @param _value The amount to be allowed.\n', '    */\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Get the allowance of an specified address to use another address balance.\n', '    * @param _owner The address of the owner of the tokens.\n', '    * @param _spender The address of the allowed spender.\n', '    */\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function approveAndCall(address spender, uint256 _value, bytes data) public returns (bool success) {\n', '        require((_value == 0) || (allowed[msg.sender][spender] == 0));\n', '        allowed[msg.sender][spender] = _value;\n', '        Approval(msg.sender, spender, _value);\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, _value, this, data);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Mint token to an specified address.\n', '    * @param _target The address of the receiver of the tokens.\n', '    * @param _mintedAmount amount to mint.\n', '    */\n', '    function mintToken(address _target, uint256 _mintedAmount) onlyAdmin supplyLock public {\n', '        require(totalSupply.add(_mintedAmount) <= 1000000000 * (10 ** 2) ); //max supply, 18 decimals\n', '        balances[_target] = SafeMath.add(balances[_target], _mintedAmount);\n', '        totalSupply = SafeMath.add(totalSupply, _mintedAmount);\n', '        Transfer(0, this, _mintedAmount);\n', '        Transfer(this, _target, _mintedAmount);\n', '    }\n', '\n', '    /**\n', '    * @dev Burn token of own address.\n', '    * @param _burnedAmount amount to burn.\n', '    */\n', '    function burnToken(uint256 _burnedAmount) onlyAdmin supplyLock public {\n', '        balances[msg.sender] = SafeMath.sub(balances[msg.sender], _burnedAmount);\n', '        totalSupply = SafeMath.sub(totalSupply, _burnedAmount);\n', '        Burned(msg.sender, _burnedAmount);\n', '    }\n', '\n', '    /**\n', '    * @dev Log Events\n', '    */\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Burned(address indexed _target, uint256 _value);\n', '}\n', '\n', '/**\n', '* @title Asset\n', '* @dev Initial supply creation\n', '*/\n', 'contract Asset is ERC20Token {\n', "    string public name = 'PGcoin';\n", '    uint8 public decimals = 2;\n', "    string public symbol = 'PGC';\n", "    string public version = '1';\n", '\n', '    function Asset() public {\n', '        totalSupply = 200000000 * (10 ** uint256(decimals)); //initial token creation\n', '        balances[msg.sender] = totalSupply;\n', '        setSupplyLock(true);\n', '\n', '        Transfer(0, this, totalSupply);\n', '        Transfer(this, msg.sender, balances[msg.sender]);\n', '    }\n', '    \n', '    /**\n', '    *@dev Function to handle callback calls\n', '    */\n', '    function() public {\n', '        revert();\n', '    }\n', '\n', '}']