['pragma solidity ^0.4.18;\n', '\n', '\n', '\n', 'library SafeMath {\n', '\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '\n', '        c = a + b;\n', '\n', '        require(c >= a);\n', '\n', '    }\n', '\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '\n', '        require(b <= a);\n', '\n', '        c = a - b;\n', '\n', '    }\n', '\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '\n', '        c = a * b;\n', '\n', '        require(a == 0 || c / a == b);\n', '\n', '    }\n', '\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '\n', '        require(b > 0);\n', '\n', '        c = a / b;\n', '\n', '    }\n', '\n', '}\n', '\n', 'contract Ownable {\n', '\n', '\n', '\n', '  address public owner;\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    if (msg.sender != owner) {\n', '      throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', 'contract ERC918Interface {\n', '  function totalSupply() public constant returns (uint);\n', '  function getMiningDifficulty() public constant returns (uint);\n', '  function getMiningTarget() public constant returns (uint);\n', '  function getMiningReward() public constant returns (uint);\n', '  function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '\n', '  function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success);\n', '\n', '  event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);\n', '\n', '}\n', '\n', '/*\n', 'The owner (or anyone) will deposit tokens in here\n', 'The owner calls the multisend method to send out payments\n', '*/\n', 'contract MintHelper is Ownable {\n', '\n', '  using SafeMath for uint;\n', '\n', '    string public name;\n', '\n', '\n', '    address public mintableToken;\n', '\n', '    address public payoutsWallet;\n', '    address public minterWallet;\n', '\n', '    uint public minterFeePercent;\n', '\n', '\n', '    function MintHelper(address mToken, address pWallet, address mWallet)\n', '    {\n', '      mintableToken = mToken;\n', '      payoutsWallet = pWallet;\n', '      minterWallet = mWallet;\n', '      minterFeePercent = 5;\n', '    }\n', '\n', '    function setMintableToken(address mToken)\n', '    public onlyOwner\n', '    returns (bool)\n', '    {\n', '      mintableToken = mToken;\n', '      return true;\n', '    }\n', '\n', '    function setPayoutsWallet(address pWallet)\n', '    public onlyOwner\n', '    returns (bool)\n', '    {\n', '      payoutsWallet = pWallet;\n', '      return true;\n', '    }\n', '\n', '    function setMinterWallet(address mWallet)\n', '    public onlyOwner\n', '    returns (bool)\n', '    {\n', '      minterWallet = mWallet;\n', '      return true;\n', '    }\n', '\n', '    function setMinterFeePercent(uint fee)\n', '    public onlyOwner\n', '    returns (bool)\n', '    {\n', '      require(fee >= 0 && fee <= 100);\n', '      minterFeePercent = fee;\n', '      return true;\n', '    }\n', '\n', '    function setName(string newName)\n', '    public onlyOwner\n', '    returns (bool)\n', '    {\n', '      name = newName;\n', '      return true;\n', '    }\n', '\n', '    function proxyMint(uint256 nonce, bytes32 challenge_digest )\n', '//    public onlyOwner  //does not need to be only owner, owner will get paid\n', '    returns (bool)\n', '    {\n', '      //identify the rewards that will be won and how to split them up\n', '      uint totalReward = ERC918Interface(mintableToken).getMiningReward();\n', '\n', '      uint minterReward = totalReward.mul(minterFeePercent).div(100);\n', '      uint payoutReward = totalReward.sub(minterReward);\n', '\n', '      // get paid in new tokens\n', '      require(ERC918Interface(mintableToken).mint(nonce, challenge_digest));\n', '\n', '      //transfer the tokens to the correct wallets\n', '      require(ERC20Interface(mintableToken).transfer(minterWallet, minterReward));\n', '      require(ERC20Interface(mintableToken).transfer(payoutsWallet, payoutReward));\n', '\n', '      return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    //withdraw any eth inside\n', '    function withdraw()\n', '    public onlyOwner\n', '    {\n', '        msg.sender.transfer(this.balance);\n', '    }\n', '\n', '    //send tokens out\n', '    function send(address _tokenAddr, address dest, uint value)\n', '    public onlyOwner\n', '    returns (bool)\n', '    {\n', '     return ERC20Interface(_tokenAddr).transfer(dest, value);\n', '    }\n', '\n', '\n', '\n', '\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '\n', '\n', 'library SafeMath {\n', '\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '\n', '        c = a + b;\n', '\n', '        require(c >= a);\n', '\n', '    }\n', '\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '\n', '        require(b <= a);\n', '\n', '        c = a - b;\n', '\n', '    }\n', '\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '\n', '        c = a * b;\n', '\n', '        require(a == 0 || c / a == b);\n', '\n', '    }\n', '\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '\n', '        require(b > 0);\n', '\n', '        c = a / b;\n', '\n', '    }\n', '\n', '}\n', '\n', 'contract Ownable {\n', '\n', '\n', '\n', '  address public owner;\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    if (msg.sender != owner) {\n', '      throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', 'contract ERC918Interface {\n', '  function totalSupply() public constant returns (uint);\n', '  function getMiningDifficulty() public constant returns (uint);\n', '  function getMiningTarget() public constant returns (uint);\n', '  function getMiningReward() public constant returns (uint);\n', '  function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '\n', '  function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success);\n', '\n', '  event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);\n', '\n', '}\n', '\n', '/*\n', 'The owner (or anyone) will deposit tokens in here\n', 'The owner calls the multisend method to send out payments\n', '*/\n', 'contract MintHelper is Ownable {\n', '\n', '  using SafeMath for uint;\n', '\n', '    string public name;\n', '\n', '\n', '    address public mintableToken;\n', '\n', '    address public payoutsWallet;\n', '    address public minterWallet;\n', '\n', '    uint public minterFeePercent;\n', '\n', '\n', '    function MintHelper(address mToken, address pWallet, address mWallet)\n', '    {\n', '      mintableToken = mToken;\n', '      payoutsWallet = pWallet;\n', '      minterWallet = mWallet;\n', '      minterFeePercent = 5;\n', '    }\n', '\n', '    function setMintableToken(address mToken)\n', '    public onlyOwner\n', '    returns (bool)\n', '    {\n', '      mintableToken = mToken;\n', '      return true;\n', '    }\n', '\n', '    function setPayoutsWallet(address pWallet)\n', '    public onlyOwner\n', '    returns (bool)\n', '    {\n', '      payoutsWallet = pWallet;\n', '      return true;\n', '    }\n', '\n', '    function setMinterWallet(address mWallet)\n', '    public onlyOwner\n', '    returns (bool)\n', '    {\n', '      minterWallet = mWallet;\n', '      return true;\n', '    }\n', '\n', '    function setMinterFeePercent(uint fee)\n', '    public onlyOwner\n', '    returns (bool)\n', '    {\n', '      require(fee >= 0 && fee <= 100);\n', '      minterFeePercent = fee;\n', '      return true;\n', '    }\n', '\n', '    function setName(string newName)\n', '    public onlyOwner\n', '    returns (bool)\n', '    {\n', '      name = newName;\n', '      return true;\n', '    }\n', '\n', '    function proxyMint(uint256 nonce, bytes32 challenge_digest )\n', '//    public onlyOwner  //does not need to be only owner, owner will get paid\n', '    returns (bool)\n', '    {\n', '      //identify the rewards that will be won and how to split them up\n', '      uint totalReward = ERC918Interface(mintableToken).getMiningReward();\n', '\n', '      uint minterReward = totalReward.mul(minterFeePercent).div(100);\n', '      uint payoutReward = totalReward.sub(minterReward);\n', '\n', '      // get paid in new tokens\n', '      require(ERC918Interface(mintableToken).mint(nonce, challenge_digest));\n', '\n', '      //transfer the tokens to the correct wallets\n', '      require(ERC20Interface(mintableToken).transfer(minterWallet, minterReward));\n', '      require(ERC20Interface(mintableToken).transfer(payoutsWallet, payoutReward));\n', '\n', '      return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    //withdraw any eth inside\n', '    function withdraw()\n', '    public onlyOwner\n', '    {\n', '        msg.sender.transfer(this.balance);\n', '    }\n', '\n', '    //send tokens out\n', '    function send(address _tokenAddr, address dest, uint value)\n', '    public onlyOwner\n', '    returns (bool)\n', '    {\n', '     return ERC20Interface(_tokenAddr).transfer(dest, value);\n', '    }\n', '\n', '\n', '\n', '\n', '}']