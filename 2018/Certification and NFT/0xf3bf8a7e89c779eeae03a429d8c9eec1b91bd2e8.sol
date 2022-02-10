['pragma solidity ^0.4.24;\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', 'contract MinimalTokenInterface {\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '    function decimals() public returns (uint8);\n', '}\n', '\n', 'contract TokenPriveProviderInterface {\n', '    function tokenPrice() public constant returns (uint);\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Dividends implementation interface\n', '// ----------------------------------------------------------------------------\n', 'contract SNcoin_CountrySale is Owned {\n', '    MinimalTokenInterface public tokenContract;\n', '    address public spenderAddress;\n', '    address public vaultAddress;\n', '    address public ambassadorAddress;\n', '    bool public fundingEnabled;\n', '    uint public totalCollected;         // In wei\n', '    TokenPriveProviderInterface public tokenPriceProvider;         // In wei\n', '    string public country;\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    constructor(address _tokenAddress, address _spenderAddress, address _vaultAddress, address _ambassadorAddress, bool _fundingEnabled, address _tokenPriceProvider, string _country) public {\n', '        require (_tokenAddress != 0);\n', '        require (_spenderAddress != 0);\n', '        require (_vaultAddress != 0);\n', '        require (_tokenPriceProvider != 0);\n', '        require (bytes(_country).length > 0);\n', '        tokenContract = MinimalTokenInterface(_tokenAddress);\n', '        spenderAddress = _spenderAddress;\n', '        vaultAddress = _vaultAddress;\n', '        ambassadorAddress = _ambassadorAddress;\n', '        fundingEnabled = _fundingEnabled;\n', '        tokenPriceProvider = TokenPriveProviderInterface(_tokenPriceProvider);\n', '        country = _country;\n', '    }\n', '\n', '    function setSpenderAddress(address _spenderAddress) public onlyOwner {\n', '        require (_spenderAddress != 0);\n', '        spenderAddress = _spenderAddress;\n', '        return;\n', '    }\n', '\n', '    function setVaultAddress(address _vaultAddress) public onlyOwner {\n', '        require (_vaultAddress != 0);\n', '        vaultAddress = _vaultAddress;\n', '        return;\n', '    }\n', '\n', '    function setAmbassadorAddress(address _ambassadorAddress) public onlyOwner {\n', '        require (_ambassadorAddress != 0);\n', '        ambassadorAddress = _ambassadorAddress;\n', '        return;\n', '    }\n', '\n', '    function setFundingEnabled(bool _fundingEnabled) public onlyOwner {\n', '        fundingEnabled = _fundingEnabled;\n', '        return;\n', '    }\n', '\n', '    function updateTokenPriceProvider(address _newTokenPriceProvider) public onlyOwner {\n', '        require(_newTokenPriceProvider != 0);\n', '        tokenPriceProvider = TokenPriveProviderInterface(_newTokenPriceProvider);\n', '        require(tokenPriceProvider.tokenPrice() > 10**9);\n', '        return;\n', '    }\n', '\n', '    function () public payable {\n', '        require (fundingEnabled);\n', '        require (ambassadorAddress != 0);\n', '        uint tokenPrice = tokenPriceProvider.tokenPrice(); // In wei\n', '        require (tokenPrice > 10**9);\n', '        require (msg.value >= tokenPrice);\n', '\n', '        totalCollected += msg.value;\n', '        uint ambVal = (20 * msg.value)/100;\n', '        uint tokens = (msg.value * 10**uint256(tokenContract.decimals())) / tokenPrice;\n', '\n', '        require (tokenContract.transferFrom(spenderAddress, msg.sender, tokens));\n', '\n', '        //Send the ether to the vault\n', '        ambassadorAddress.transfer(ambVal);\n', '        vaultAddress.transfer(msg.value - ambVal);\n', '\n', '        return;\n', '    }\n', '\n', '    /// @notice This method can be used by the owner to extract mistakenly\n', '    ///  sent tokens to this contract.\n', '    /// @param _token The address of the token contract that you want to recover\n', '    ///  set to 0 in case you want to extract ether.\n', '    function claimTokens(address _token) public onlyOwner {\n', '        if (_token == 0x0) {\n', '            owner.transfer(address(this).balance);\n', '            return;\n', '        }\n', '\n', '        MinimalTokenInterface token = MinimalTokenInterface(_token);\n', '        uint balance = token.balanceOf(this);\n', '        token.transfer(owner, balance);\n', '        emit ClaimedTokens(_token, owner, balance);\n', '    }\n', '\n', '    event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);\n', '}']