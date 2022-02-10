['contract SafeMath {\n', '    \n', '    uint256 constant public MAX_UINT256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;\n', '\n', '    function safeAdd(uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '        require(x <= MAX_UINT256 - y);\n', '        return x + y;\n', '    }\n', '\n', '    function safeSub(uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '        require(x >= y);\n', '        return x - y;\n', '    }\n', '\n', '    function safeMul(uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '        if (y == 0) {\n', '            return 0;\n', '        }\n', '        require(x <= (MAX_UINT256 / y));\n', '        return x * y;\n', '    }\n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    function Owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        assert(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        require(_newOwner != owner);\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        OwnerUpdate(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = 0x0;\n', '    }\n', '\n', '    event OwnerUpdate(address _prevOwner, address _newOwner);\n', '}\n', '\n', '\n', 'contract Lockable is Owned {\n', '\n', '    uint256 public lockedUntilBlock;\n', '\n', '    event ContractLocked(uint256 _untilBlock, string _reason);\n', '\n', '    modifier lockAffected {\n', '        require(block.number > lockedUntilBlock);\n', '        _;\n', '    }\n', '\n', '    function lockFromSelf(uint256 _untilBlock, string _reason) internal {\n', '        lockedUntilBlock = _untilBlock;\n', '        ContractLocked(_untilBlock, _reason);\n', '    }\n', '\n', '\n', '    function lockUntil(uint256 _untilBlock, string _reason) onlyOwner public {\n', '        lockedUntilBlock = _untilBlock;\n', '        ContractLocked(_untilBlock, _reason);\n', '    }\n', '}\n', '\n', '\n', 'contract ERC20PrivateInterface {\n', '    uint256 supply;\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowances;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract tokenRecipientInterface {\n', '  function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);\n', '}\n', '\n', 'contract OwnedInterface {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    modifier onlyOwner {\n', '        _;\n', '    }\n', '}\n', '\n', 'contract ERC20TokenInterface {\n', '  function totalSupply() public constant returns (uint256 _totalSupply);\n', '  function balanceOf(address _owner) public constant returns (uint256 balance);\n', '  function transfer(address _to, uint256 _value) public returns (bool success);\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '  function approve(address _spender, uint256 _value) public returns (bool success);\n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', '\n', 'contract MintableTokenInterface {\n', '    function mint(address _to, uint256 _amount) public;\n', '}\n', '\n', 'contract MintingContract is Owned {\n', '    \n', '    address public tokenAddress;\n', '    enum state { crowdsaleMinintg, teamMinting, finished}\n', '\n', '    state public mintingState; \n', '    uint public crowdsaleMintingCap;\n', '    uint public tokensAlreadyMinted;\n', '    \n', '    uint public teamTokensPercent;\n', '    address public teamTokenAddress;\n', '    uint public communityTokens;\n', '    uint public communityTokens2;\n', '    address public communityAddress;\n', '    \n', '    constructor() public {\n', '        crowdsaleMintingCap = 570500000 * 10**18;\n', '        teamTokensPercent = 27;\n', '        teamTokenAddress = 0xc2180bC387B7944FabE5E5e25BFaC69Af2Dc888A;\n', '        communityTokens = 24450000 * 10**18;\n', '        communityTokens2 = 5705000 * 10**18;\n', '        communityAddress = 0x4FAAc921781122AA61cfE59841A7669840821b86;\n', '    }\n', '    \n', '    function doCrowdsaleMinting(address _destination, uint _tokensToMint) onlyOwner public {\n', '        require(mintingState == state.crowdsaleMinintg);\n', '        require(tokensAlreadyMinted + _tokensToMint <= crowdsaleMintingCap);\n', '        MintableTokenInterface(tokenAddress).mint(_destination, _tokensToMint);\n', '        tokensAlreadyMinted += _tokensToMint;\n', '    }\n', '    \n', '    function finishCrowdsaleMinting() onlyOwner public {\n', '        mintingState = state.teamMinting;\n', '    }\n', '    \n', '    function doTeamMinting() public {\n', '        require(mintingState == state.teamMinting);\n', '        uint onePercent = tokensAlreadyMinted/70;\n', '        MintableTokenInterface(tokenAddress).mint(communityAddress, communityTokens2);\n', '        MintableTokenInterface(tokenAddress).mint(teamTokenAddress, communityTokens - communityTokens2);\n', '        MintableTokenInterface(tokenAddress).mint(teamTokenAddress, (teamTokensPercent * onePercent));\n', '        mintingState = state.finished;\n', '    }\n', '\n', '    function setTokenAddress(address _tokenAddress) onlyOwner public {\n', '        tokenAddress = _tokenAddress;\n', '    }\n', '}']
['contract SafeMath {\n', '    \n', '    uint256 constant public MAX_UINT256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;\n', '\n', '    function safeAdd(uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '        require(x <= MAX_UINT256 - y);\n', '        return x + y;\n', '    }\n', '\n', '    function safeSub(uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '        require(x >= y);\n', '        return x - y;\n', '    }\n', '\n', '    function safeMul(uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '        if (y == 0) {\n', '            return 0;\n', '        }\n', '        require(x <= (MAX_UINT256 / y));\n', '        return x * y;\n', '    }\n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    function Owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        assert(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        require(_newOwner != owner);\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        OwnerUpdate(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = 0x0;\n', '    }\n', '\n', '    event OwnerUpdate(address _prevOwner, address _newOwner);\n', '}\n', '\n', '\n', 'contract Lockable is Owned {\n', '\n', '    uint256 public lockedUntilBlock;\n', '\n', '    event ContractLocked(uint256 _untilBlock, string _reason);\n', '\n', '    modifier lockAffected {\n', '        require(block.number > lockedUntilBlock);\n', '        _;\n', '    }\n', '\n', '    function lockFromSelf(uint256 _untilBlock, string _reason) internal {\n', '        lockedUntilBlock = _untilBlock;\n', '        ContractLocked(_untilBlock, _reason);\n', '    }\n', '\n', '\n', '    function lockUntil(uint256 _untilBlock, string _reason) onlyOwner public {\n', '        lockedUntilBlock = _untilBlock;\n', '        ContractLocked(_untilBlock, _reason);\n', '    }\n', '}\n', '\n', '\n', 'contract ERC20PrivateInterface {\n', '    uint256 supply;\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowances;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract tokenRecipientInterface {\n', '  function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);\n', '}\n', '\n', 'contract OwnedInterface {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    modifier onlyOwner {\n', '        _;\n', '    }\n', '}\n', '\n', 'contract ERC20TokenInterface {\n', '  function totalSupply() public constant returns (uint256 _totalSupply);\n', '  function balanceOf(address _owner) public constant returns (uint256 balance);\n', '  function transfer(address _to, uint256 _value) public returns (bool success);\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '  function approve(address _spender, uint256 _value) public returns (bool success);\n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', '\n', 'contract MintableTokenInterface {\n', '    function mint(address _to, uint256 _amount) public;\n', '}\n', '\n', 'contract MintingContract is Owned {\n', '    \n', '    address public tokenAddress;\n', '    enum state { crowdsaleMinintg, teamMinting, finished}\n', '\n', '    state public mintingState; \n', '    uint public crowdsaleMintingCap;\n', '    uint public tokensAlreadyMinted;\n', '    \n', '    uint public teamTokensPercent;\n', '    address public teamTokenAddress;\n', '    uint public communityTokens;\n', '    uint public communityTokens2;\n', '    address public communityAddress;\n', '    \n', '    constructor() public {\n', '        crowdsaleMintingCap = 570500000 * 10**18;\n', '        teamTokensPercent = 27;\n', '        teamTokenAddress = 0xc2180bC387B7944FabE5E5e25BFaC69Af2Dc888A;\n', '        communityTokens = 24450000 * 10**18;\n', '        communityTokens2 = 5705000 * 10**18;\n', '        communityAddress = 0x4FAAc921781122AA61cfE59841A7669840821b86;\n', '    }\n', '    \n', '    function doCrowdsaleMinting(address _destination, uint _tokensToMint) onlyOwner public {\n', '        require(mintingState == state.crowdsaleMinintg);\n', '        require(tokensAlreadyMinted + _tokensToMint <= crowdsaleMintingCap);\n', '        MintableTokenInterface(tokenAddress).mint(_destination, _tokensToMint);\n', '        tokensAlreadyMinted += _tokensToMint;\n', '    }\n', '    \n', '    function finishCrowdsaleMinting() onlyOwner public {\n', '        mintingState = state.teamMinting;\n', '    }\n', '    \n', '    function doTeamMinting() public {\n', '        require(mintingState == state.teamMinting);\n', '        uint onePercent = tokensAlreadyMinted/70;\n', '        MintableTokenInterface(tokenAddress).mint(communityAddress, communityTokens2);\n', '        MintableTokenInterface(tokenAddress).mint(teamTokenAddress, communityTokens - communityTokens2);\n', '        MintableTokenInterface(tokenAddress).mint(teamTokenAddress, (teamTokensPercent * onePercent));\n', '        mintingState = state.finished;\n', '    }\n', '\n', '    function setTokenAddress(address _tokenAddress) onlyOwner public {\n', '        tokenAddress = _tokenAddress;\n', '    }\n', '}']