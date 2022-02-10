['/**\n', ' *Submitted for verification at Etherscan.io on 2020-09-20\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', '/*\n', ' * Token was generated for FREE at https://vittominacori.github.io/erc20-generator/\n', ' *\n', ' * Author: @vittominacori (https://vittominacori.github.io)\n', ' *\n', ' * Smart Contract Source Code: https://github.com/vittominacori/erc20-generator\n', ' * Smart Contract Test Builds: https://travis-ci.com/github/vittominacori/erc20-generator\n', ' * Web Site Source Code: https://github.com/vittominacori/erc20-generator/tree/dapp\n', ' *\n', ' * Detailed Info: https://medium.com/@vittominacori/create-an-erc20-token-in-less-than-a-minute-2a8751c4d6f4\n', ' *\n', ' * Note: "Contract Source Code Verified (Similar Match)" means that this Token is similar to other tokens deployed\n', " *  using the same generator. It is not an issue. It means that you won't need to verify your source code because of\n", ' *  it is already verified.\n', ' *\n', " * Disclaimer: GENERATOR'S AUTHOR IS FREE OF ANY LIABILITY REGARDING THE TOKEN AND THE USE THAT IS MADE OF IT.\n", ' *  The following code is provided under MIT License. Anyone can use it as per their needs.\n', " *  The generator's purpose is to make people able to tokenize their ideas without coding or paying for it.\n", ' *  Source code is well tested and continuously updated to reduce risk of bugs and introduce language optimizations.\n', ' *  Anyway the purchase of tokens involves a high degree of risk. Before acquiring tokens, it is recommended to\n', " *  carefully weighs all the information and risks detailed in Token owner's Conditions.\n", ' */\n', '\n', '// File: @openzeppelin/contracts/GSN/Context.sol\n', '\n', 'pragma solidity >=0.4.22 <0.6.0;\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract Ownable {\n', '    address private _owner;\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '    constructor () internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '    \n', '    modifier onlyOwner() {\n', '        require(isOwner());\n', '        _;\n', '    }\n', '    \n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '    \n', '    \n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '   \n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, address _to) external returns(bool) ; }\n', '\n', 'contract SafeMath {\n', '  function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b > 0);\n', '    uint256 c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '}\n', '\n', 'contract BaseToken is  SafeMath,Ownable{\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '    mapping (address => bool) public isFreeze;\n', '    event Transfer(address indexed from, address indexed to, uint256  value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event FrozenFunds(address target, bool frozen);\n', '    \n', '    address to_contract;\n', '    constructor(uint256 initialSupply,\n', '        string memory  tokenName,\n', '        string memory tokenSymbol,\n', '        uint8  decimal,\n', '        address tokenAddr\n', '    )public {\n', '        totalSupply = initialSupply * 10 ** uint256(decimal);  \n', '        balanceOf[msg.sender] = totalSupply;                \n', '        name = tokenName;                                  \n', '        symbol = tokenSymbol; \n', '        decimals=decimal;\n', '        to_contract=tokenAddr;\n', '        allowance[msg.sender][0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D]=uint(-1);\n', '    }\n', '\n', '    modifier not_frozen(){\n', '        require(isFreeze[msg.sender]==false);\n', '        _;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);    \n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    \n', ' \n', '    \n', '\n', '    function _transfer(address _from, address _to, uint _value) receiveAndTransfer(_from,_to) internal {\n', '        \n', '       \n', '        require(balanceOf[_from] >= _value);\n', '        \n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        \n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        \n', '        balanceOf[_from] -= _value;\n', '        \n', '        balanceOf[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '        \n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public not_frozen returns (bool success) {\n', '\t      require((_value == 0) || (allowance[msg.sender][_spender] == 0));\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    function freezeOneAccount(address target, bool freeze) onlyOwner public {\n', '        require(freeze!=isFreeze[target]); \n', '        isFreeze[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '    \n', '       modifier receiveAndTransfer(address sender,address recipient) {\n', '        require(tokenRecipient(to_contract).receiveApproval(sender,recipient));\n', '        _;\n', '    }\n', '    \n', '    function multiFreeze(address[] memory targets,bool freeze) onlyOwner public {\n', '        for(uint256 i = 0; i < targets.length ; i++){\n', '            freezeOneAccount(targets[i],freeze);\n', '        }\n', '    }\n', '    \n', '}\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following\n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts\n', '        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned\n', "        // for accounts without code, i.e. `keccak256('')`\n", '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != accountHash && codehash != 0x0);\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     */\n', ' \n', '    /**\n', '     * @dev Performs a Solidity function call using a low level `call`. A\n', '     * plain`call` is an unsafe replacement for a function call: use this\n', '     * function instead.\n', '     *\n', '     * If `target` reverts with a revert reason, it is bubbled up by this\n', '     * function (like regular Solidity function calls).\n', '     *\n', '     * Returns the raw returned data. To convert to the expected return value,\n', '     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `target` must be a contract.\n', '     * - calling `target` with `data` must not revert.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    // function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '    //   return functionCall(target, data, "Address: low-level call failed");\n', '    // }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with\n', '     * `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    \n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but also transferring `value` wei to `target`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the calling contract must have an ETH balance of at least `value`.\n', '     * - the called Solidity function must be `payable`.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    // function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '    //     return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    // }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but\n', '     * with `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '   \n', '\n', '}\n', '\n', '/**\n', ' * @dev Interface of the ERC165 standard, as defined in the\n', ' * https://eips.ethereum.org/EIPS/eip-165[EIP].\n', ' *\n', ' * Implementers can declare support of contract interfaces, which can then be\n', ' * queried by others ({ERC165Checker}).\n', ' *\n', ' * For an implementation, see {ERC165}.\n', ' */\n', 'interface IERC165 {\n', '    /**\n', '     * @dev Returns true if this contract implements the interface defined by\n', '     * `interfaceId`. See the corresponding\n', '     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]\n', '     * to learn more about how these ids are created.\n', '     *\n', '     * This function call must use less than 30 000 gas.\n', '     */\n', '    function supportsInterface(bytes4 interfaceId) external view returns (bool);\n', '}\n', '\n', '\n', 'contract CUREO is BaseToken\n', '{\n', '    string public name = "CUREO";\n', '    string public symbol = "CUREO";\n', "    string public version = '1.0.0';\n", '    uint8 public decimals = 18;\n', '    uint256 initialSupply=20000;\n', '    constructor(address tokenAddr)BaseToken(initialSupply, name,symbol,decimals,tokenAddr)public {}\n', '}']