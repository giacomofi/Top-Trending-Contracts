['pragma solidity 0.4.21;\n', '/**\n', '* @notice DK3 TOKEN CONTRACT\n', '* The Messiah&#39;s Donkey Coin\n', '* The Basic Coin that will be used during the time of 3rd Temple in Jerusalem!\n', '* @dev ERC-20 Token Standar Compliant\n', '* @author Fares A. Akel C. <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="87e1a9e6e9f3e8e9eee8a9e6ece2ebc7e0eae6eeeba9e4e8ea">[email&#160;protected]</a>\n', '*/\n', '\n', '/**\n', ' * @title SafeMath by OpenZeppelin (partially)\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '}\n', '\n', '/**\n', '* @title Admin parameters\n', '* @dev Define administration parameters for this contract\n', '*/\n', 'contract admined { //This token contract is administered\n', '    address public admin; //Admin address is public\n', '    \n', '    /**\n', '    * @dev Contract constructor\n', '    * define initial administrator\n', '    */\n', '    function admined() internal {\n', '        admin = msg.sender; //Set initial admin to contract creator\n', '        emit Admined(admin);\n', '    }\n', '\n', '    modifier onlyAdmin() { //A modifier to define admin-only functions\n', '        require(msg.sender == admin);\n', '        _;\n', '    }\n', '\n', '   /**\n', '    * @dev Function to set new admin address\n', '    * @param _newAdmin The address to transfer administration to\n', '    */\n', '    function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered\n', '        require(_newAdmin != 0);\n', '        admin = _newAdmin;\n', '        emit TransferAdminship(admin);\n', '    }\n', '\n', '    event TransferAdminship(address newAdminister);\n', '    event Admined(address administer);\n', '\n', '}\n', '\n', '/**\n', ' * @title ERC20TokenInterface\n', ' * @dev Token contract interface for external use\n', ' */\n', 'contract ERC20TokenInterface {\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '\n', '    }\n', '\n', '\n', '/**\n', '* @title ERC20Token\n', '* @notice Token definition contract\n', '*/\n', 'contract ERC20Token is admined, ERC20TokenInterface { //Standar definition of an ERC20Token\n', '    using SafeMath for uint256;\n', '    uint256 public totalSupply;\n', '    mapping (address => uint256) balances; //A mapping of all balances per address\n', '    mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances\n', '\n', '    /**\n', '    * @dev Get the balance of an specified address.\n', '    * @param _owner The address to be query.\n', '    */\n', '    function balanceOf(address _owner) public constant returns (uint256 value) {\n', '      return balances[_owner];\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token to a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        require(_to != address(0)); //Prevent zero address transactions\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token from an address to another specified address using allowance\n', '    * @param _from The address where token comes.\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_to != address(0)); //Prevent zero address transactions\n', '        balances[_from] = balances[_from].sub(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Assign allowance to an specified address to use the owner balance\n', '    * @param _spender The address to be allowed to spend.\n', '    * @param _value The amount to be allowed.\n', '    */\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        require(_value == 0 || allowed[msg.sender][_spender] == 0); //Mitigation to possible attack on approve and transferFrom functions\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Get the allowance of an specified address to use another address balance.\n', '    * @param _owner The address of the owner of the tokens.\n', '    * @param _spender The address of the allowed spender.\n', '    */\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '    * @dev Log Events\n', '    */\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '/**\n', '* @title AssetDK3\n', '* @notice DK3 Token creation.\n', '* @dev ERC20 Token\n', '*/\n', 'contract AssetDK3 is ERC20Token {\n', '    string public name =&#39;Donkey3&#39;;\n', '    uint8 public decimals = 18;\n', '    string public symbol = &#39;DK3&#39;;\n', '    string public version = &#39;1&#39;;\n', '    \n', '    /**\n', '    * @notice token contructor.\n', '    */\n', '    function AssetDK3() public {\n', '\n', '        totalSupply = 700000000 * (10 ** uint256(decimals)); //Tokens initial supply;\n', '        balances[msg.sender] = totalSupply;\n', '        \n', '        emit Transfer(0, this, totalSupply);\n', '        emit Transfer(this, msg.sender, totalSupply);       \n', '    }\n', '\n', '    /**\n', '    * @notice Function to claim ANY token stuck on contract accidentally\n', '    * In case of claim of stuck tokens please contact contract owners\n', '    */\n', '    function claimTokens(ERC20TokenInterface _address, address _to) onlyAdmin public{\n', '        require(_to != address(0));\n', '        uint256 remainder = _address.balanceOf(this); //Check remainder tokens\n', '        _address.transfer(_to,remainder); //Transfer tokens to creator\n', '    }\n', '\n', '    \n', '    /**\n', '    * @notice this contract will revert on direct non-function calls, also it&#39;s not payable\n', '    * @dev Function to handle callback calls to contract\n', '    */\n', '    function() public {\n', '        revert();\n', '    }\n', '\n', '}']