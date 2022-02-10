['pragma solidity ^0.4.19; \n', '/*\n', 'Author: Vox / 0xPool.io\n', 'Description: This smart contract is designed to store mining pool payouts for \n', '  Ethereum Protocol tokens and allow pool miners to withdraw their earned tokens\n', '  whenever they please. There are several benefits to using a smart contract to\n', '  track mining pool payouts:\n', '    - Increased transparency on behalf of pool owners\n', '    - Allows users more control over the regularity of their mining payouts\n', '    - The pool admin does not need to pay the gas costs of hundreds of \n', '      micro-transactions every time a block reward is found by the pool.\n', '\n', 'This contract is the 0xBTC (0xBitcoin) payout account for: http://0xpool.io \n', '\n', 'Not heard of 0xBitcoin? Head over to http://0xbitcoin.org\n', '*/\n', '\n', 'contract ERC20Interface {\n', '\n', '    function totalSupply() public constant returns (uint);\n', '\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '\n', '}\n', '\n', '\n', 'contract _ERC20Pool {\n', '  ERC20Interface public tokenContract = ERC20Interface(0xB6eD7644C69416d67B522e20bC294A9a9B405B31);\n', '\n', '  address public owner = msg.sender;\n', '  uint32 public totalTokenSupply;\n', '  mapping (address => uint32) public minerTokens;\n', '  mapping (address => uint32) public minerTokenPayouts;\n', '\n', '  // Modifier for important owner only functions\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  // Require that the caller actually has tokens to withdraw.\n', '  modifier hasTokens(address sentFrom) {\n', '    require(minerTokens[sentFrom] > 0);\n', '    _;\n', '  }\n', '\n', '  // Pool software updates the contract when it finds a reward\n', '  function addMinerTokens(uint32 totalTokensInBatch, address[] minerAddress, uint32[] minerRewardTokens) public onlyOwner {\n', '    totalTokenSupply += totalTokensInBatch;\n', '    for (uint i = 0; i < minerAddress.length; i ++) {\n', '      minerTokens[minerAddress[i]] += minerRewardTokens[i];\n', '    }\n', '  }\n', '\n', '  // Allow miners to withdraw their earnings from the contract. Update internal accounting.\n', '  function withdraw() public\n', '    hasTokens(msg.sender) \n', '  {\n', '    uint32 amount = minerTokens[msg.sender];\n', '    minerTokens[msg.sender] = 0;\n', '    totalTokenSupply -= amount;\n', '    minerTokenPayouts[msg.sender] += amount;\n', '    tokenContract.transfer(msg.sender, amount);\n', '  }\n', '\n', '  // Fallback function, Ether sent to this contract will be considered as a donation towards the \n', '  // 0xPool project unless you get in contact with 0xPool.io within 72 hours. \n', '  function () public payable {\n', '    owner.transfer(msg.value);\n', '  }\n', '\n', '}']