['pragma solidity ^0.4.25;\n', '\n', '\n', '/// @title Version\n', 'contract Version {\n', '    string public semanticVersion;\n', '\n', '    /// @notice Constructor saves a public version of the deployed Contract.\n', '    /// @param _version Semantic version of the contract.\n', '    constructor(string _version) internal {\n', '        semanticVersion = _version;\n', '    }\n', '}\n', '\n', '\n', '/// @title Factory\n', 'contract Factory is Version {\n', '    event FactoryAddedContract(address indexed _contract);\n', '\n', '    modifier contractHasntDeployed(address _contract) {\n', '        require(contracts[_contract] == false);\n', '        _;\n', '    }\n', '\n', '    mapping(address => bool) public contracts;\n', '\n', '    constructor(string _version) internal Version(_version) {}\n', '\n', '    function hasBeenDeployed(address _contract) public constant returns (bool) {\n', '        return contracts[_contract];\n', '    }\n', '\n', '    function addContract(address _contract)\n', '        internal\n', '        contractHasntDeployed(_contract)\n', '        returns (bool)\n', '    {\n', '        contracts[_contract] = true;\n', '        emit FactoryAddedContract(_contract);\n', '        return true;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'interface ERC20 {\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address who) external view returns (uint256);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'contract SpendableWallet is Ownable {\n', '    ERC20 public token;\n', '\n', '    event ClaimedTokens(\n', '        address indexed _token,\n', '        address indexed _controller,\n', '        uint256 _amount\n', '    );\n', '\n', '    constructor(address _token, address _owner) public {\n', '        token = ERC20(_token);\n', '        owner = _owner;\n', '    }\n', '\n', '    function spend(address _to, uint256 _amount) public onlyOwner {\n', '        require(\n', '            token.transfer(_to, _amount),\n', '            "Token transfer could not be executed."\n', '        );\n', '    }\n', '\n', '    /// @notice This method can be used by the controller to extract mistakenly\n', '    ///  sent tokens to this contract.\n', '    /// @param _token The address of the token contract that you want to recover\n', '    ///  set to 0 in case you want to extract ether.\n', '    function claimTokens(address _token) public onlyOwner {\n', '        if (_token == 0x0) {\n', '            owner.transfer(address(this).balance);\n', '            return;\n', '        }\n', '\n', '        ERC20 erc20token = ERC20(_token);\n', '        uint256 balance = erc20token.balanceOf(address(this));\n', '        require(\n', '            erc20token.transfer(owner, balance),\n', '            "Token transfer could not be executed."\n', '        );\n', '        emit ClaimedTokens(_token, owner, balance);\n', '    }\n', '}\n', '\n', '\n', 'contract SpendableWalletFactory is Factory {\n', '    // index of created contracts\n', '    address[] public spendableWallets;\n', '\n', '    constructor() public Factory("1.0.3") {}\n', '\n', '    // deploy a new contract\n', '    function newPaymentAddress(address _token, address _owner)\n', '        public\n', '        returns(address newContract)\n', '    {\n', '        SpendableWallet spendableWallet = new SpendableWallet(_token, _owner);\n', '        spendableWallets.push(spendableWallet);\n', '        addContract(spendableWallet);\n', '        return spendableWallet;\n', '    }\n', '}']