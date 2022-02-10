['pragma solidity ^0.4.23;\n', '\n', '/**\n', ' * @title Eliptic curve signature operations\n', ' *\n', ' * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d\n', ' *\n', ' * TODO Remove this library once solidity supports passing a signature to ecrecover.\n', ' * See https://github.com/ethereum/solidity/issues/864\n', ' *\n', ' */\n', '\n', 'library ECRecoveryLibrary {\n', '\n', '    /**\n', '     * @dev Recover signer address from a message by using their signature\n', '     * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.\n', '     * @param sig bytes signature, the signature is generated using web3.eth.sign()\n', '     */\n', '    function recover(bytes32 hash, bytes sig) internal pure returns (address) {\n', '        bytes32 r;\n', '        bytes32 s;\n', '        uint8 v;\n', '\n', '        // Check the signature length\n', '        if (sig.length != 65) {\n', '            return (address(0));\n', '        }\n', '\n', '        // Divide the signature in r, s and v variables\n', '        // ecrecover takes the signature parameters, and the only way to get them\n', '        // currently is to use assembly.\n', '        // solium-disable-next-line security/no-inline-assembly\n', '        assembly {\n', '            r := mload(add(sig, 32))\n', '            s := mload(add(sig, 64))\n', '            v := byte(0, mload(add(sig, 96)))\n', '        }\n', '\n', '        // Version of signature should be 27 or 28, but 0 and 1 are also possible versions\n', '        if (v < 27) {\n', '            v += 27;\n', '        }\n', '\n', '        // If the version is correct return the signer address\n', '        if (v != 27 && v != 28) {\n', '            return (address(0));\n', '        } else {\n', '            // solium-disable-next-line arg-overflow\n', '            return ecrecover(hash, v, r, s);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * toEthSignedMessageHash\n', '     * @dev prefix a bytes32 value with "\\x19Ethereum Signed Message:"\n', '     * @dev and hash the result\n', '     */\n', '    function toEthSignedMessageHash(bytes32 hash)\n', '    internal\n', '    pure\n', '    returns (bytes32)\n', '    {\n', '        // 32 is the length in bytes of hash,\n', '        // enforced by the type signature above\n', '        return keccak256(\n', '            "\\x19Ethereum Signed Message:\\n32",\n', '            hash\n', '        );\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMathLibrary {\n', '\n', '    function max(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param _newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address _newOwner) onlyOwner public {\n', '        require(_newOwner != address(0));\n', '        emit OwnershipTransferred(owner, _newOwner);\n', '        owner = _newOwner;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '    bool public paused = false;\n', '\n', '    event Pause();\n', '\n', '    event Unpause();\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is paused.\n', '     */\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to pause, triggers stopped state\n', '     */\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to unpause, returns to normal state\n', '     */\n', '    function unpause() onlyOwner whenPaused public {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '}\n', '\n', 'interface TokenReceiver {\n', '    function tokenFallback(address _from, uint _value) external returns(bool);\n', '}\n', '\n', 'contract Token is Pausable {\n', '    using SafeMathLibrary for uint;\n', '\n', '    using ECRecoveryLibrary for bytes32;\n', '\n', '    uint public decimals = 18;\n', '\n', '    mapping (address => uint) balances;\n', '\n', '    mapping (address => mapping (address => uint)) allowed;\n', '\n', '    mapping(bytes => bool) signatures;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '\n', '    event DelegatedTransfer(address indexed from, address indexed to, address indexed delegate, uint amount, uint fee);\n', '\n', '    function () {\n', '        revert();\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    *\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) constant public returns (uint) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    *\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint _value) whenNotPaused public returns (bool) {\n', '        require(_to != address(0) && _value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        callTokenFallback(_to, msg.sender, _value);\n', '\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function delegatedTransfer(bytes _signature, address _to, uint _value, uint _fee, uint _nonce) whenNotPaused public returns (bool) {\n', '        require(_to != address(0) && signatures[_signature] == false);\n', '\n', '        bytes32 hashedTx = hashDelegatedTransfer(_to, _value, _fee, _nonce);\n', '        address from = hashedTx.recover(_signature);\n', '\n', '        require(from != address(0) && _value.add(_fee) <= balances[from]);\n', '\n', '        balances[from] = balances[from].sub(_value).sub(_fee);\n', '        balances[_to] = balances[_to].add(_value);\n', '        balances[msg.sender] = balances[msg.sender].add(_fee);\n', '\n', '        signatures[_signature] = true;\n', '\n', '        callTokenFallback(_to, from, _value);\n', '\n', '        emit Transfer(from, _to, _value);\n', '        emit Transfer(from, msg.sender, _fee);\n', '        emit DelegatedTransfer(from, _to, msg.sender, _value, _fee);\n', '        return true;\n', '    }\n', '\n', '    function hashDelegatedTransfer(address _to, uint _value, uint _fee, uint _nonce) public view returns (bytes32) {\n', '        /* “45b56ba6”: delegatedTransfer(bytes,address,uint,uint,uint) */ // orig: 48664c16\n', '        return keccak256(bytes4(0x45b56ba6), address(this), _to, _value, _fee, _nonce);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     *\n', '     * @param _from The address which you want to send tokens from\n', '     * @param _to The address which you want to transfer to\n', '     * @param _value the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from, address _to, uint _value) whenNotPaused public returns (bool ok) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '\n', '        callTokenFallback(_to, _from, _value);\n', '\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     *\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '     * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint _value) whenNotPaused public returns (bool ok) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address _owner, address _spender) constant public returns (uint) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseApproval(address _spender, uint _addedValue) whenNotPaused public returns (bool success) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseApproval(address _spender, uint _subtractedValue) whenNotPaused public returns (bool success) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function callTokenFallback(address _contract, address _from, uint _value) internal {\n', '        if (isContract(_contract)) {\n', '            require(contracts[_contract] != address(0) && balances[_contract] >= contractHoldBalance);\n', '            TokenReceiver receiver = TokenReceiver(_contract);\n', '            require(receiver.tokenFallback(_from, _value));\n', '        }\n', '    }\n', '\n', '    function isContract(address _address) internal view returns(bool) {\n', '        uint length;\n', '        assembly {\n', '            length := extcodesize(_address)\n', '        }\n', '        return (length > 0);\n', '    }\n', '\n', '    // contract => owner\n', '    mapping (address => address) contracts;\n', '\n', '    uint contractHoldBalance = 500 * 10 ** decimals;\n', '\n', '    function setContractHoldBalance(uint _value) whenNotPaused onlyOwner public returns(bool) {\n', '        contractHoldBalance = _value;\n', '        return true;\n', '    }\n', '\n', '    function register(address _contract) whenNotPaused public returns(bool) {\n', '        require(isContract(_contract) && contracts[_contract] == address(0) && balances[msg.sender] >= contractHoldBalance);\n', '        balances[msg.sender] = balances[msg.sender].sub(contractHoldBalance);\n', '        balances[_contract] = balances[_contract].add(contractHoldBalance);\n', '        contracts[_contract] = msg.sender;\n', '        return true;\n', '    }\n', '\n', '    function unregister(address _contract) whenNotPaused public returns(bool) {\n', '        require(isContract(_contract) && contracts[_contract] == msg.sender);\n', '        balances[_contract] = balances[_contract].sub(contractHoldBalance);\n', '        balances[msg.sender] = balances[msg.sender].add(contractHoldBalance);\n', '        delete contracts[_contract];\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract CATT is Token {\n', '    string public name = "Content Aggregation Transfer Token";\n', '\n', '    string public symbol = "CATT";\n', '\n', '    uint public totalSupply = 5000000000 * 10 ** decimals;\n', '\n', '    constructor() public {\n', '        balances[owner] = totalSupply;\n', '    }\n', '}']
['pragma solidity ^0.4.23;\n', '\n', '/**\n', ' * @title Eliptic curve signature operations\n', ' *\n', ' * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d\n', ' *\n', ' * TODO Remove this library once solidity supports passing a signature to ecrecover.\n', ' * See https://github.com/ethereum/solidity/issues/864\n', ' *\n', ' */\n', '\n', 'library ECRecoveryLibrary {\n', '\n', '    /**\n', '     * @dev Recover signer address from a message by using their signature\n', '     * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.\n', '     * @param sig bytes signature, the signature is generated using web3.eth.sign()\n', '     */\n', '    function recover(bytes32 hash, bytes sig) internal pure returns (address) {\n', '        bytes32 r;\n', '        bytes32 s;\n', '        uint8 v;\n', '\n', '        // Check the signature length\n', '        if (sig.length != 65) {\n', '            return (address(0));\n', '        }\n', '\n', '        // Divide the signature in r, s and v variables\n', '        // ecrecover takes the signature parameters, and the only way to get them\n', '        // currently is to use assembly.\n', '        // solium-disable-next-line security/no-inline-assembly\n', '        assembly {\n', '            r := mload(add(sig, 32))\n', '            s := mload(add(sig, 64))\n', '            v := byte(0, mload(add(sig, 96)))\n', '        }\n', '\n', '        // Version of signature should be 27 or 28, but 0 and 1 are also possible versions\n', '        if (v < 27) {\n', '            v += 27;\n', '        }\n', '\n', '        // If the version is correct return the signer address\n', '        if (v != 27 && v != 28) {\n', '            return (address(0));\n', '        } else {\n', '            // solium-disable-next-line arg-overflow\n', '            return ecrecover(hash, v, r, s);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * toEthSignedMessageHash\n', '     * @dev prefix a bytes32 value with "\\x19Ethereum Signed Message:"\n', '     * @dev and hash the result\n', '     */\n', '    function toEthSignedMessageHash(bytes32 hash)\n', '    internal\n', '    pure\n', '    returns (bytes32)\n', '    {\n', '        // 32 is the length in bytes of hash,\n', '        // enforced by the type signature above\n', '        return keccak256(\n', '            "\\x19Ethereum Signed Message:\\n32",\n', '            hash\n', '        );\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMathLibrary {\n', '\n', '    function max(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return a / b;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param _newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address _newOwner) onlyOwner public {\n', '        require(_newOwner != address(0));\n', '        emit OwnershipTransferred(owner, _newOwner);\n', '        owner = _newOwner;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '    bool public paused = false;\n', '\n', '    event Pause();\n', '\n', '    event Unpause();\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is paused.\n', '     */\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to pause, triggers stopped state\n', '     */\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to unpause, returns to normal state\n', '     */\n', '    function unpause() onlyOwner whenPaused public {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '}\n', '\n', 'interface TokenReceiver {\n', '    function tokenFallback(address _from, uint _value) external returns(bool);\n', '}\n', '\n', 'contract Token is Pausable {\n', '    using SafeMathLibrary for uint;\n', '\n', '    using ECRecoveryLibrary for bytes32;\n', '\n', '    uint public decimals = 18;\n', '\n', '    mapping (address => uint) balances;\n', '\n', '    mapping (address => mapping (address => uint)) allowed;\n', '\n', '    mapping(bytes => bool) signatures;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '\n', '    event DelegatedTransfer(address indexed from, address indexed to, address indexed delegate, uint amount, uint fee);\n', '\n', '    function () {\n', '        revert();\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    *\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) constant public returns (uint) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    *\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint _value) whenNotPaused public returns (bool) {\n', '        require(_to != address(0) && _value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        callTokenFallback(_to, msg.sender, _value);\n', '\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function delegatedTransfer(bytes _signature, address _to, uint _value, uint _fee, uint _nonce) whenNotPaused public returns (bool) {\n', '        require(_to != address(0) && signatures[_signature] == false);\n', '\n', '        bytes32 hashedTx = hashDelegatedTransfer(_to, _value, _fee, _nonce);\n', '        address from = hashedTx.recover(_signature);\n', '\n', '        require(from != address(0) && _value.add(_fee) <= balances[from]);\n', '\n', '        balances[from] = balances[from].sub(_value).sub(_fee);\n', '        balances[_to] = balances[_to].add(_value);\n', '        balances[msg.sender] = balances[msg.sender].add(_fee);\n', '\n', '        signatures[_signature] = true;\n', '\n', '        callTokenFallback(_to, from, _value);\n', '\n', '        emit Transfer(from, _to, _value);\n', '        emit Transfer(from, msg.sender, _fee);\n', '        emit DelegatedTransfer(from, _to, msg.sender, _value, _fee);\n', '        return true;\n', '    }\n', '\n', '    function hashDelegatedTransfer(address _to, uint _value, uint _fee, uint _nonce) public view returns (bytes32) {\n', '        /* “45b56ba6”: delegatedTransfer(bytes,address,uint,uint,uint) */ // orig: 48664c16\n', '        return keccak256(bytes4(0x45b56ba6), address(this), _to, _value, _fee, _nonce);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     *\n', '     * @param _from The address which you want to send tokens from\n', '     * @param _to The address which you want to transfer to\n', '     * @param _value the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from, address _to, uint _value) whenNotPaused public returns (bool ok) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '\n', '        callTokenFallback(_to, _from, _value);\n', '\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     *\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint _value) whenNotPaused public returns (bool ok) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address _owner, address _spender) constant public returns (uint) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseApproval(address _spender, uint _addedValue) whenNotPaused public returns (bool success) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseApproval(address _spender, uint _subtractedValue) whenNotPaused public returns (bool success) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function callTokenFallback(address _contract, address _from, uint _value) internal {\n', '        if (isContract(_contract)) {\n', '            require(contracts[_contract] != address(0) && balances[_contract] >= contractHoldBalance);\n', '            TokenReceiver receiver = TokenReceiver(_contract);\n', '            require(receiver.tokenFallback(_from, _value));\n', '        }\n', '    }\n', '\n', '    function isContract(address _address) internal view returns(bool) {\n', '        uint length;\n', '        assembly {\n', '            length := extcodesize(_address)\n', '        }\n', '        return (length > 0);\n', '    }\n', '\n', '    // contract => owner\n', '    mapping (address => address) contracts;\n', '\n', '    uint contractHoldBalance = 500 * 10 ** decimals;\n', '\n', '    function setContractHoldBalance(uint _value) whenNotPaused onlyOwner public returns(bool) {\n', '        contractHoldBalance = _value;\n', '        return true;\n', '    }\n', '\n', '    function register(address _contract) whenNotPaused public returns(bool) {\n', '        require(isContract(_contract) && contracts[_contract] == address(0) && balances[msg.sender] >= contractHoldBalance);\n', '        balances[msg.sender] = balances[msg.sender].sub(contractHoldBalance);\n', '        balances[_contract] = balances[_contract].add(contractHoldBalance);\n', '        contracts[_contract] = msg.sender;\n', '        return true;\n', '    }\n', '\n', '    function unregister(address _contract) whenNotPaused public returns(bool) {\n', '        require(isContract(_contract) && contracts[_contract] == msg.sender);\n', '        balances[_contract] = balances[_contract].sub(contractHoldBalance);\n', '        balances[msg.sender] = balances[msg.sender].add(contractHoldBalance);\n', '        delete contracts[_contract];\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract CATT is Token {\n', '    string public name = "Content Aggregation Transfer Token";\n', '\n', '    string public symbol = "CATT";\n', '\n', '    uint public totalSupply = 5000000000 * 10 ** decimals;\n', '\n', '    constructor() public {\n', '        balances[owner] = totalSupply;\n', '    }\n', '}']