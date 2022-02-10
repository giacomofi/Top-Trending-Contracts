['// File: openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Unsigned math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '    /**\n', '    * @dev Multiplies two unsigned integers, reverts on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two unsigned integers, reverts on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '    * reverts when dividing by zero.\n', '    */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'interface IERC20 {\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address who) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/cryptography/ECDSA.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @title Elliptic curve signature operations\n', ' * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d\n', ' * TODO Remove this library once solidity supports passing a signature to ecrecover.\n', ' * See https://github.com/ethereum/solidity/issues/864\n', ' */\n', '\n', 'library ECDSA {\n', '    /**\n', '     * @dev Recover signer address from a message by using their signature\n', '     * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.\n', '     * @param signature bytes signature, the signature is generated using web3.eth.sign()\n', '     */\n', '    function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {\n', '        bytes32 r;\n', '        bytes32 s;\n', '        uint8 v;\n', '\n', '        // Check the signature length\n', '        if (signature.length != 65) {\n', '            return (address(0));\n', '        }\n', '\n', '        // Divide the signature in r, s and v variables\n', '        // ecrecover takes the signature parameters, and the only way to get them\n', '        // currently is to use assembly.\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly {\n', '            r := mload(add(signature, 0x20))\n', '            s := mload(add(signature, 0x40))\n', '            v := byte(0, mload(add(signature, 0x60)))\n', '        }\n', '\n', '        // Version of signature should be 27 or 28, but 0 and 1 are also possible versions\n', '        if (v < 27) {\n', '            v += 27;\n', '        }\n', '\n', '        // If the version is correct return the signer address\n', '        if (v != 27 && v != 28) {\n', '            return (address(0));\n', '        } else {\n', '            return ecrecover(hash, v, r, s);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * toEthSignedMessageHash\n', '     * @dev prefix a bytes32 value with "\\x19Ethereum Signed Message:"\n', '     * and hash the result\n', '     */\n', '    function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {\n', '        // 32 is the length in bytes of hash,\n', '        // enforced by the type signature above\n', '        return keccak256(abi.encodePacked("\\x19Ethereum Signed Message:\\n32", hash));\n', '    }\n', '}\n', '\n', '// File: contracts/IndexedMerkleProof.sol\n', '\n', 'pragma solidity ^0.5.5;\n', '\n', '\n', 'library IndexedMerkleProof {\n', '    function compute(bytes memory proof, uint160 leaf) internal pure returns (uint160 root, uint256 index) {\n', '        uint160 computedHash = leaf;\n', '\n', '        for (uint256 i = 0; i < proof.length / 20; i++) {\n', '            uint160 proofElement;\n', '            // solium-disable-next-line security/no-inline-assembly\n', '            assembly {\n', '                proofElement := div(mload(add(proof, add(32, mul(i, 20)))), 0x1000000000000000000000000)\n', '            }\n', '\n', '            if (computedHash < proofElement) {\n', '                // Hash(current computed hash + current element of the proof)\n', '                computedHash = uint160(uint256(keccak256(abi.encodePacked(computedHash, proofElement))));\n', '                index += (1 << i);\n', '            } else {\n', '                // Hash(current element of the proof + current computed hash)\n', '                computedHash = uint160(uint256(keccak256(abi.encodePacked(proofElement, computedHash))));\n', '            }\n', '        }\n', '\n', '        return (computedHash, index);\n', '    }\n', '}\n', '\n', '// File: contracts/InstaLend.sol\n', '\n', 'pragma solidity ^0.5.5;\n', '\n', '\n', '\n', '\n', 'contract InstaLend {\n', '    using SafeMath for uint;\n', '\n', '    address private _feesReceiver;\n', '    uint256 private _feesPercent;\n', '    bool private _inLendingMode;\n', '\n', '    modifier notInLendingMode {\n', '        require(!_inLendingMode);\n', '        _;\n', '    }\n', '\n', '    constructor(address receiver, uint256 percent) public {\n', '        _feesReceiver = receiver;\n', '        _feesPercent = percent;\n', '    }\n', '\n', '    function feesReceiver() public view returns(address) {\n', '        return _feesReceiver;\n', '    }\n', '\n', '    function feesPercent() public view returns(uint256) {\n', '        return _feesPercent;\n', '    }\n', '\n', '    function lend(\n', '        IERC20[] memory tokens,\n', '        uint256[] memory amounts,\n', '        address target,\n', '        bytes memory data\n', '    )\n', '        public\n', '        notInLendingMode\n', '    {\n', '        _inLendingMode = true;\n', '\n', '        // Backup original balances and lend tokens\n', '        uint256[] memory prevAmounts = new uint256[](tokens.length);\n', '        for (uint i = 0; i < tokens.length; i++) {\n', '            prevAmounts[i] = tokens[i].balanceOf(address(this));\n', '            require(tokens[i].transfer(target, amounts[i]));\n', '        }\n', '\n', '        // Perform arbitrary call\n', '        (bool res,) = target.call(data);    // solium-disable-line security/no-low-level-calls\n', '        require(res, "Invalid arbitrary call");\n', '\n', '        // Ensure original balances were restored\n', '        for (uint i = 0; i < tokens.length; i++) {\n', '            uint256 expectedFees = amounts[i].mul(_feesPercent).div(100);\n', '            require(tokens[i].balanceOf(address(this)) >= prevAmounts[i].add(expectedFees));\n', '            if (_feesReceiver != address(this)) {\n', '                require(tokens[i].transfer(_feesReceiver, expectedFees));\n', '            }\n', '        }\n', '\n', '        _inLendingMode = false;\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md\n', ' * Originally based on code by FirstBlood:\n', ' * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' *\n', ' * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for\n', " * all accounts just by listening to said events. Note that this isn't required by the specification, and other\n", ' * compliant implementations may not do it.\n', ' */\n', 'contract ERC20 is IERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) private _balances;\n', '\n', '    mapping (address => mapping (address => uint256)) private _allowed;\n', '\n', '    uint256 private _totalSupply;\n', '\n', '    /**\n', '    * @dev Total number of tokens in existence\n', '    */\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param owner The address to query the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address owner) public view returns (uint256) {\n', '        return _balances[owner];\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param owner address The address which owns the funds.\n', '     * @param spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address owner, address spender) public view returns (uint256) {\n', '        return _allowed[owner][spender];\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer token for a specified address\n', '    * @param to The address to transfer to.\n', '    * @param value The amount to be transferred.\n', '    */\n', '    function transfer(address to, uint256 value) public returns (bool) {\n', '        _transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param spender The address which will spend the funds.\n', '     * @param value The amount of tokens to be spent.\n', '     */\n', '    function approve(address spender, uint256 value) public returns (bool) {\n', '        require(spender != address(0));\n', '\n', '        _allowed[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another.\n', '     * Note that while this function emits an Approval event, this is not required as per the specification,\n', '     * and other compliant implementations may not emit the event.\n', '     * @param from address The address which you want to send tokens from\n', '     * @param to address The address which you want to transfer to\n', '     * @param value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '        _transfer(from, to, value);\n', '        emit Approval(from, msg.sender, _allowed[from][msg.sender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when allowed_[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * Emits an Approval event.\n', '     * @param spender The address which will spend the funds.\n', '     * @param addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '        require(spender != address(0));\n', '\n', '        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);\n', '        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when allowed_[_spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * Emits an Approval event.\n', '     * @param spender The address which will spend the funds.\n', '     * @param subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '        require(spender != address(0));\n', '\n', '        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);\n', '        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer token for a specified addresses\n', '    * @param from The address to transfer from.\n', '    * @param to The address to transfer to.\n', '    * @param value The amount to be transferred.\n', '    */\n', '    function _transfer(address from, address to, uint256 value) internal {\n', '        require(to != address(0));\n', '\n', '        _balances[from] = _balances[from].sub(value);\n', '        _balances[to] = _balances[to].add(value);\n', '        emit Transfer(from, to, value);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function that mints an amount of the token and assigns it to\n', '     * an account. This encapsulates the modification of balances such that the\n', '     * proper events are emitted.\n', '     * @param account The account that will receive the created tokens.\n', '     * @param value The amount that will be created.\n', '     */\n', '    function _mint(address account, uint256 value) internal {\n', '        require(account != address(0));\n', '\n', '        _totalSupply = _totalSupply.add(value);\n', '        _balances[account] = _balances[account].add(value);\n', '        emit Transfer(address(0), account, value);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function that burns an amount of the token of a given\n', '     * account.\n', '     * @param account The account whose tokens will be burnt.\n', '     * @param value The amount that will be burnt.\n', '     */\n', '    function _burn(address account, uint256 value) internal {\n', '        require(account != address(0));\n', '\n', '        _totalSupply = _totalSupply.sub(value);\n', '        _balances[account] = _balances[account].sub(value);\n', '        emit Transfer(account, address(0), value);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function that burns an amount of the token of a given\n', "     * account, deducting from the sender's allowance for said account. Uses the\n", '     * internal burn function.\n', '     * Emits an Approval event (reflecting the reduced allowance).\n', '     * @param account The account whose tokens will be burnt.\n', '     * @param value The amount that will be burnt.\n', '     */\n', '    function _burnFrom(address account, uint256 value) internal {\n', '        _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);\n', '        _burn(account, value);\n', '        emit Approval(account, msg.sender, _allowed[account][msg.sender]);\n', '    }\n', '}\n', '\n', '// File: contracts/CheckedERC20.sol\n', '\n', 'pragma solidity ^0.5.5;\n', '\n', '\n', '\n', '\n', 'library CheckedERC20 {\n', '    using SafeMath for uint;\n', '\n', '    function isContract(IERC20 addr) internal view returns(bool result) {\n', '        // solium-disable-next-line security/no-inline-assembly\n', '        assembly {\n', '            result := gt(extcodesize(addr), 0)\n', '        }\n', '    }\n', '\n', '    function handleReturnBool() internal pure returns(bool result) {\n', '        // solium-disable-next-line security/no-inline-assembly\n', '        assembly {\n', '            switch returndatasize()\n', '            case 0 { // not a std erc20\n', '                result := 1\n', '            }\n', '            case 32 { // std erc20\n', '                returndatacopy(0, 0, 32)\n', '                result := mload(0)\n', '            }\n', '            default { // anything else, should revert for safety\n', '                revert(0, 0)\n', '            }\n', '        }\n', '    }\n', '\n', '    function handleReturnBytes32() internal pure returns(bytes32 result) {\n', '        // solium-disable-next-line security/no-inline-assembly\n', '        assembly {\n', '            switch eq(returndatasize(), 32) // not a std erc20\n', '            case 1 {\n', '                returndatacopy(0, 0, 32)\n', '                result := mload(0)\n', '            }\n', '\n', '            switch gt(returndatasize(), 32) // std erc20\n', '            case 1 {\n', '                returndatacopy(0, 64, 32)\n', '                result := mload(0)\n', '            }\n', '\n', '            switch lt(returndatasize(), 32) // anything else, should revert for safety\n', '            case 1 {\n', '                revert(0, 0)\n', '            }\n', '        }\n', '    }\n', '\n', '    function asmTransfer(IERC20 token, address to, uint256 value) internal returns(bool) {\n', '        require(isContract(token));\n', '        // solium-disable-next-line security/no-low-level-calls\n', '        (bool res,) = address(token).call(abi.encodeWithSignature("transfer(address,uint256)", to, value));\n', '        require(res);\n', '        return handleReturnBool();\n', '    }\n', '\n', '    function asmTransferFrom(IERC20 token, address from, address to, uint256 value) internal returns(bool) {\n', '        require(isContract(token));\n', '        // solium-disable-next-line security/no-low-level-calls\n', '        (bool res,) = address(token).call(abi.encodeWithSignature("transferFrom(address,address,uint256)", from, to, value));\n', '        require(res);\n', '        return handleReturnBool();\n', '    }\n', '\n', '    function asmApprove(IERC20 token, address spender, uint256 value) internal returns(bool) {\n', '        require(isContract(token));\n', '        // solium-disable-next-line security/no-low-level-calls\n', '        (bool res,) = address(token).call(abi.encodeWithSignature("approve(address,uint256)", spender, value));\n', '        require(res);\n', '        return handleReturnBool();\n', '    }\n', '\n', '    //\n', '\n', '    function checkedTransfer(IERC20 token, address to, uint256 value) internal {\n', '        if (value > 0) {\n', '            uint256 balance = token.balanceOf(address(this));\n', '            asmTransfer(token, to, value);\n', '            require(token.balanceOf(address(this)) == balance.sub(value), "checkedTransfer: Final balance didn\'t match");\n', '        }\n', '    }\n', '\n', '    function checkedTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        if (value > 0) {\n', '            uint256 toBalance = token.balanceOf(to);\n', '            asmTransferFrom(token, from, to, value);\n', '            require(token.balanceOf(to) == toBalance.add(value), "checkedTransfer: Final balance didn\'t match");\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/IKyberNetwork.sol\n', '\n', 'pragma solidity ^0.5.2;\n', '\n', '\n', 'contract IKyberNetwork {\n', '    function trade(\n', '        address src,\n', '        uint256 srcAmount,\n', '        address dest,\n', '        address destAddress,\n', '        uint256 maxDestAmount,\n', '        uint256 minConversionRate,\n', '        address walletId\n', '    )\n', '        public\n', '        payable\n', '        returns(uint);\n', '\n', '    function getExpectedRate(\n', '        address source,\n', '        address dest,\n', '        uint srcQty\n', '    )\n', '        public\n', '        view\n', '        returns (\n', '            uint expectedPrice,\n', '            uint slippagePrice\n', '        );\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor () internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @return the address of the owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner());\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @return true if `msg.sender` is the owner of the contract.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to relinquish control of the contract.\n', '     * @notice Renouncing to ownership will leave the contract without an owner.\n', '     * It will not be possible to call the functions with the `onlyOwner`\n', '     * modifier anymore.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: contracts/AnyPaymentReceiver.sol\n', '\n', 'pragma solidity ^0.5.5;\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract AnyPaymentReceiver is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    address constant public ETHER_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;\n', '\n', '    function _processPayment(\n', '        IKyberNetwork kyber,\n', '        address desiredToken,\n', '        address paymentToken,\n', '        uint256 paymentAmount\n', '    )\n', '        internal\n', '        returns(uint256)\n', '    {\n', '        uint256 previousBalance = _balanceOf(desiredToken);\n', '\n', '        // Receive payment\n', '        if (paymentToken != address(0)) {\n', '            require(IERC20(paymentToken).transferFrom(msg.sender, address(this), paymentAmount));\n', '        } else {\n', '            require(msg.value >= paymentAmount);\n', '        }\n', '\n', '        // Convert payment if needed\n', '        if (paymentToken != desiredToken) {\n', '            if (paymentToken != address(0)) {\n', '                IERC20(paymentToken).approve(address(kyber), paymentAmount);\n', '            }\n', '\n', '            kyber.trade.value(msg.value)(\n', '                (paymentToken == address(0)) ? ETHER_ADDRESS : paymentToken,\n', '                (paymentToken == address(0)) ? msg.value : paymentAmount,\n', '                (desiredToken == address(0)) ? ETHER_ADDRESS : desiredToken,\n', '                address(this),\n', '                1 << 255,\n', '                0,\n', '                address(0)\n', '            );\n', '        }\n', '\n', '        uint256 currentBalance = _balanceOf(desiredToken);\n', '        return currentBalance.sub(previousBalance);\n', '    }\n', '\n', '    function _balanceOf(address token) internal view returns(uint256) {\n', '        if (token == address(0)) {\n', '            return address(this).balance;\n', '        }\n', '        return IERC20(token).balanceOf(address(this));\n', '    }\n', '\n', '    function _returnRemainder(address payable renter, IERC20 token, uint256 remainder) internal {\n', '        if (token == IERC20(0)) {\n', '            renter.transfer(remainder);\n', '        } else {\n', '            token.transfer(renter, remainder);\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/QRToken.sol\n', '\n', 'pragma solidity ^0.5.5;\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract QRToken is InstaLend, AnyPaymentReceiver {\n', '    using SafeMath for uint;\n', '    using ECDSA for bytes;\n', '    using IndexedMerkleProof for bytes;\n', '    using CheckedERC20 for IERC20;\n', '\n', '    uint256 constant public MAX_CODES_COUNT = 1024;\n', '    uint256 constant public MAX_WORDS_COUNT = (MAX_CODES_COUNT + 31) / 32;\n', '\n', '    struct Distribution {\n', '        IERC20 token;\n', '        uint256 sumAmount;\n', '        uint256 codesCount;\n', '        uint256 deadline;\n', '        address sponsor;\n', '        uint256[32] bitMask; // MAX_WORDS_COUNT\n', '    }\n', '\n', '    mapping(uint160 => Distribution) public distributions;\n', '\n', '    event Created();\n', '    event Redeemed(uint160 root, uint256 index, address receiver);\n', '\n', '    constructor()\n', '        public\n', '        InstaLend(msg.sender, 1)\n', '    {\n', '    }\n', '\n', '    function create(\n', '        IERC20 token,\n', '        uint256 sumTokenAmount,\n', '        uint256 codesCount,\n', '        uint160 root,\n', '        uint256 deadline\n', '    )\n', '        external\n', '        notInLendingMode\n', '    {\n', '        require(0 < sumTokenAmount);\n', '        require(0 < codesCount && codesCount <= MAX_CODES_COUNT);\n', '        require(deadline > now);\n', '\n', '        token.checkedTransferFrom(msg.sender, address(this), sumTokenAmount);\n', '        Distribution storage distribution = distributions[root];\n', '        distribution.token = token;\n', '        distribution.sumAmount = sumTokenAmount;\n', '        distribution.codesCount = codesCount;\n', '        distribution.deadline = deadline;\n', '        distribution.sponsor = msg.sender;\n', '    }\n', '\n', '    function redeemed(uint160 root, uint index) public view returns(bool) {\n', '        Distribution storage distribution = distributions[root];\n', '        return distribution.bitMask[index / 32] & (1 << (index % 32)) != 0;\n', '    }\n', '\n', '    function redeem(\n', '        bytes calldata signature,\n', '        bytes calldata merkleProof\n', '    )\n', '        external\n', '        notInLendingMode\n', '    {\n', '        bytes32 messageHash = keccak256(abi.encodePacked(msg.sender));\n', '        bytes32 signedHash = ECDSA.toEthSignedMessageHash(messageHash);\n', '        address signer = ECDSA.recover(signedHash, signature);\n', '        uint160 signerHash = uint160(uint256(keccak256(abi.encodePacked(signer))));\n', '        (uint160 root, uint256 index) = merkleProof.compute(signerHash);\n', '        Distribution storage distribution = distributions[root];\n', '        require(distribution.bitMask[index / 32] & (1 << (index % 32)) == 0);\n', '\n', '        distribution.bitMask[index / 32] = distribution.bitMask[index / 32] | (1 << (index % 32));\n', '        distribution.token.checkedTransfer(msg.sender, distribution.sumAmount.div(distribution.codesCount));\n', '        emit Redeemed(root, index, msg.sender);\n', '    }\n', '\n', '    function redeemWithFee(\n', '        IKyberNetwork kyber, // 0x818E6FECD516Ecc3849DAf6845e3EC868087B755\n', '        address receiver,\n', '        uint256 feePrecent,\n', '        bytes calldata signature,\n', '        bytes calldata merkleProof\n', '    )\n', '        external\n', '        notInLendingMode\n', '    {\n', '        bytes32 messageHash = ECDSA.toEthSignedMessageHash(keccak256(abi.encodePacked(receiver, feePrecent)));\n', '        uint160 signerHash = uint160(uint256(keccak256(abi.encodePacked(ECDSA.recover(messageHash, signature)))));\n', '        (uint160 root, uint256 index) = merkleProof.compute(signerHash);\n', '        Distribution storage distribution = distributions[root];\n', '        require(distribution.bitMask[index / 32] & (1 << (index % 32)) == 0);\n', '\n', '        distribution.bitMask[index / 32] = distribution.bitMask[index / 32] | (1 << (index % 32));\n', '        uint256 reward = distribution.sumAmount.div(distribution.codesCount);\n', '        uint256 fee = reward.mul(feePrecent).div(100);\n', '        distribution.token.checkedTransfer(receiver, reward.sub(fee));\n', '        emit Redeemed(root, index, msg.sender);\n', '\n', '        uint256 gotEther = _processPayment(kyber, ETHER_ADDRESS, address(distribution.token), fee);\n', '        msg.sender.transfer(gotEther);\n', '    }\n', '\n', '    function abort(uint160 root)\n', '        public\n', '        notInLendingMode\n', '    {\n', '        Distribution storage distribution = distributions[root];\n', '        require(now > distribution.deadline);\n', '\n', '        uint256 count = 0;\n', '        for (uint i = 0; i < 1024; i++) {\n', '            if (distribution.bitMask[i / 32] & (1 << (i % 32)) != 0) {\n', '                count += distribution.sumAmount / distribution.codesCount;\n', '            }\n', '        }\n', '        distribution.token.checkedTransfer(distribution.sponsor, distribution.sumAmount.sub(count));\n', '        delete distributions[root];\n', '    }\n', '}']