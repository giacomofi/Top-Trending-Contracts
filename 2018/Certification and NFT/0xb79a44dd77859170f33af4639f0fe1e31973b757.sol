['pragma solidity ^0.4.24;\n', '\n', '// File: zeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/lifecycle/Destructible.sol\n', '\n', '/**\n', ' * @title Destructible\n', ' * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.\n', ' */\n', 'contract Destructible is Ownable {\n', '\n', '  function Destructible() payable { }\n', '\n', '  /**\n', '   * @dev Transfers the current balance to the owner and terminates the contract.\n', '   */\n', '  function destroy() onlyOwner public {\n', '    selfdestruct(owner);\n', '  }\n', '\n', '  function destroyAndSend(address _recipient) onlyOwner public {\n', '    selfdestruct(_recipient);\n', '  }\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/lifecycle/Pausable.sol\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    Unpause();\n', '  }\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/ownership/Contactable.sol\n', '\n', '/**\n', ' * @title Contactable token\n', ' * @dev Basic version of a contactable contract, allowing the owner to provide a string with their\n', ' * contact information.\n', ' */\n', 'contract Contactable is Ownable{\n', '\n', '    string public contactInformation;\n', '\n', '    /**\n', '     * @dev Allows the owner to set a string with their contact information.\n', '     * @param info The contact information to attach to the contract.\n', '     */\n', '    function setContactInformation(string info) onlyOwner public {\n', '         contactInformation = info;\n', '     }\n', '}\n', '\n', '// File: contracts/Restricted.sol\n', '\n', '/** @title Restricted\n', ' *  Exposes onlyMonetha modifier\n', ' */\n', 'contract Restricted is Ownable {\n', '\n', '    //MonethaAddress set event\n', '    event MonethaAddressSet(\n', '        address _address,\n', '        bool _isMonethaAddress\n', '    );\n', '\n', '    mapping (address => bool) public isMonethaAddress;\n', '\n', '    /**\n', '     *  Restrict methods in such way, that they can be invoked only by monethaAddress account.\n', '     */\n', '    modifier onlyMonetha() {\n', '        require(isMonethaAddress[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     *  Allows owner to set new monetha address\n', '     */\n', '    function setMonethaAddress(address _address, bool _isMonethaAddress) onlyOwner public {\n', '        isMonethaAddress[_address] = _isMonethaAddress;\n', '\n', '        MonethaAddressSet(_address, _isMonethaAddress);\n', '    }\n', '}\n', '\n', '// File: contracts/ERC20.sol\n', '\n', '/**\n', '* @title ERC20 interface\n', '*/\n', 'contract ERC20 {\n', '    function totalSupply() public view returns (uint256);\n', '\n', '    function decimals() public view returns(uint256);\n', '\n', '    function balanceOf(address _who) public view returns (uint256);\n', '\n', '    function allowance(address _owner, address _spender)\n', '        public view returns (uint256);\n', '        \n', '    // Return type not defined intentionally since not all ERC20 tokens return proper result type\n', '    function transfer(address _to, uint256 _value) public;\n', '\n', '    function approve(address _spender, uint256 _value)\n', '        public returns (bool);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value)\n', '        public returns (bool);\n', '\n', '    event Transfer(\n', '        address indexed from,\n', '        address indexed to,\n', '        uint256 value\n', '    );\n', '\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 value\n', '    );\n', '}\n', '\n', '// File: contracts/MonethaGateway.sol\n', '\n', '/**\n', ' *  @title MonethaGateway\n', ' *\n', " *  MonethaGateway forward funds from order payment to merchant's wallet and collects Monetha fee.\n", ' */\n', 'contract MonethaGateway is Pausable, Contactable, Destructible, Restricted {\n', '\n', '    using SafeMath for uint256;\n', '    \n', '    string constant VERSION = "0.5";\n', '\n', '    /**\n', '     *  Fee permille of Monetha fee.\n', '     *  1 permille (‰) = 0.1 percent (%)\n', '     *  15‰ = 1.5%\n', '     */\n', '    uint public constant FEE_PERMILLE = 15;\n', '    \n', '    /**\n', '     *  Address of Monetha Vault for fee collection\n', '     */\n', '    address public monethaVault;\n', '\n', '    /**\n', '     *  Account for permissions managing\n', '     */\n', '    address public admin;\n', '\n', '    event PaymentProcessedEther(address merchantWallet, uint merchantIncome, uint monethaIncome);\n', '    event PaymentProcessedToken(address tokenAddress, address merchantWallet, uint merchantIncome, uint monethaIncome);\n', '\n', '    /**\n', '     *  @param _monethaVault Address of Monetha Vault\n', '     */\n', '    constructor(address _monethaVault, address _admin) public {\n', '        require(_monethaVault != 0x0);\n', '        monethaVault = _monethaVault;\n', '        \n', '        setAdmin(_admin);\n', '    }\n', '    \n', '    /**\n', "     *  acceptPayment accept payment from PaymentAcceptor, forwards it to merchant's wallet\n", '     *      and collects Monetha fee.\n', "     *  @param _merchantWallet address of merchant's wallet for fund transfer\n", '     *  @param _monethaFee is a fee collected by Monetha\n', '     */\n', '    function acceptPayment(address _merchantWallet, uint _monethaFee) external payable onlyMonetha whenNotPaused {\n', '        require(_merchantWallet != 0x0);\n', '        require(_monethaFee >= 0 && _monethaFee <= FEE_PERMILLE.mul(msg.value).div(1000)); // Monetha fee cannot be greater than 1.5% of payment\n', '        \n', '        uint merchantIncome = msg.value.sub(_monethaFee);\n', '\n', '        _merchantWallet.transfer(merchantIncome);\n', '        monethaVault.transfer(_monethaFee);\n', '\n', '        emit PaymentProcessedEther(_merchantWallet, merchantIncome, _monethaFee);\n', '    }\n', '\n', '    /**\n', "     *  acceptTokenPayment accept token payment from PaymentAcceptor, forwards it to merchant's wallet\n", '     *      and collects Monetha fee.\n', "     *  @param _merchantWallet address of merchant's wallet for fund transfer\n", '     *  @param _monethaFee is a fee collected by Monetha\n', '     *  @param _tokenAddress is the token address\n', '     *  @param _value is the order value\n', '     */\n', '    function acceptTokenPayment(\n', '        address _merchantWallet,\n', '        uint _monethaFee,\n', '        address _tokenAddress,\n', '        uint _value\n', '    )\n', '        external onlyMonetha whenNotPaused\n', '    {\n', '        require(_merchantWallet != 0x0);\n', '\n', '        // Monetha fee cannot be greater than 1.5% of payment\n', '        require(_monethaFee >= 0 && _monethaFee <= FEE_PERMILLE.mul(_value).div(1000));\n', '\n', '        uint merchantIncome = _value.sub(_monethaFee);\n', '        \n', '        ERC20(_tokenAddress).transfer(_merchantWallet, merchantIncome);\n', '        ERC20(_tokenAddress).transfer(monethaVault, _monethaFee);\n', '        \n', '        emit PaymentProcessedToken(_tokenAddress, _merchantWallet, merchantIncome, _monethaFee);\n', '    }\n', '\n', '    /**\n', '     *  changeMonethaVault allows owner to change address of Monetha Vault.\n', '     *  @param newVault New address of Monetha Vault\n', '     */\n', '    function changeMonethaVault(address newVault) external onlyOwner whenNotPaused {\n', '        monethaVault = newVault;\n', '    }\n', '\n', '    /**\n', '     *  Allows other monetha account or contract to set new monetha address\n', '     */\n', '    function setMonethaAddress(address _address, bool _isMonethaAddress) public {\n', '        require(msg.sender == admin || msg.sender == owner);\n', '\n', '        isMonethaAddress[_address] = _isMonethaAddress;\n', '\n', '        emit MonethaAddressSet(_address, _isMonethaAddress);\n', '    }\n', '\n', '    /**\n', '     *  setAdmin allows owner to change address of admin.\n', '     *  @param _admin New address of admin\n', '     */\n', '    function setAdmin(address _admin) public onlyOwner {\n', '        require(_admin != 0x0);\n', '        admin = _admin;\n', '    }\n', '}']