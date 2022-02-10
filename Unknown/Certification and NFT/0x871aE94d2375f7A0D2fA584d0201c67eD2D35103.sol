['pragma solidity ^0.4.4;\n', '\n', 'contract DigiPulse {\n', '\n', '\t// Token data for ERC20\n', '  string public constant name = "DigiPulse";\n', '  string public constant symbol = "DGT";\n', '  uint8 public constant decimals = 8;\n', '  mapping (address => uint256) public balanceOf;\n', '\n', '  // Max available supply is 16581633 * 1e8 (incl. 100000 presale and 2% bounties)\n', '  uint constant tokenSupply = 16125000 * 1e8;\n', '  uint8 constant dgtRatioToEth = 250;\n', '  uint constant raisedInPresale = 961735343125;\n', '  mapping (address => uint256) ethBalanceOf;\n', '  address owner;\n', '\n', '  // For LIVE\n', '  uint constant startOfIco = 1501833600; // 08/04/2017 @ 8:00am (UTC)\n', '  uint constant endOfIco = 1504223999; // 08/31/2017 @ 23:59pm (UTC)\n', '\n', '  uint allocatedSupply = 0;\n', '  bool icoFailed = false;\n', '  bool icoFulfilled = false;\n', '\n', '  // Generate public event that will notify clients\n', '\tevent Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Refund(address indexed _from, uint256 _value);\n', '\n', '  // No special actions are required upon creation, so initialiser is left empty\n', '  function DigiPulse() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  // For future transfers of DGT\n', '  function transfer(address _to, uint256 _value) {\n', '    require (balanceOf[msg.sender] >= _value);          // Check if the sender has enough\n', '    require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows\n', '\n', '    balanceOf[msg.sender] -= _value;                    // Subtract from the sender\n', '    balanceOf[_to] += _value;                           // Add the same to the recipient\n', '\n', '    Transfer(msg.sender, _to, _value);\n', '  }\n', '\n', '  // logic which converts eth to dgt and stores in allocatedSupply\n', '  function() payable external {\n', '    // Abort if crowdfunding has reached an end\n', '    require (now > startOfIco);\n', '    require (now < endOfIco);\n', '    require (!icoFulfilled);\n', '\n', '    // Do not allow creating 0 tokens\n', '    require (msg.value != 0);\n', '\n', '    // Must adjust number of decimals, so the ratio will work as expected\n', '    // From ETH 16 decimals to DGT 8 decimals\n', '    uint256 dgtAmount = msg.value / 1e10 * dgtRatioToEth;\n', '    require (dgtAmount < (tokenSupply - allocatedSupply));\n', '\n', '    // Tier bonus calculations\n', '    uint256 dgtWithBonus;\n', '    uint256 applicable_for_tier;\n', '\n', '    for (uint8 i = 0; i < 4; i++) {\n', '      // Each tier has same amount of DGT\n', '      uint256 tier_amount = 3275000 * 1e8;\n', '      // Every next tier has 5% less bonus pool\n', '      uint8 tier_bonus = 115 - (i * 5);\n', '      applicable_for_tier += tier_amount;\n', '\n', '      // Skipping over this tier, since it is filled already\n', '      if (allocatedSupply >= applicable_for_tier) continue;\n', '\n', '      // Reached this tier with 0 amount, so abort\n', '      if (dgtAmount == 0) break;\n', '\n', '      // Cases when part of the contribution is covering two tiers\n', '      int256 diff = int(allocatedSupply) + int(dgtAmount - applicable_for_tier);\n', '\n', '      if (diff > 0) {\n', '        // add bonus for current tier and strip the difference for\n', '        // calculation in the next tier\n', '        dgtWithBonus += (uint(int(dgtAmount) - diff) * tier_bonus / 100);\n', '        dgtAmount = uint(diff);\n', '      } else {\n', '        dgtWithBonus += (dgtAmount * tier_bonus / 100);\n', '        dgtAmount = 0;\n', '      }\n', '    }\n', '\n', '    // Increase supply\n', '    allocatedSupply += dgtWithBonus;\n', '\n', '    // Assign new tokens to the sender and log token creation event\n', '    ethBalanceOf[msg.sender] += msg.value;\n', '    balanceOf[msg.sender] += dgtWithBonus;\n', '    Transfer(0, msg.sender, dgtWithBonus);\n', '  }\n', '\n', '  // Decide the state of the project\n', '  function finalise() external {\n', '    require (!icoFailed);\n', '    require (!icoFulfilled);\n', '    require (now > endOfIco || allocatedSupply >= tokenSupply);\n', '\n', '    // Min cap is 8000 ETH\n', '    if (this.balance < 8000 ether) {\n', '      icoFailed = true;\n', '    } else {\n', '      setPreSaleAmounts();\n', '      allocateBountyTokens();\n', '      icoFulfilled = true;\n', '    }\n', '  }\n', '\n', '  // If the goal is not reached till the end of the ICO\n', '  // allow refunds\n', '  function refundEther() external {\n', '  \trequire (icoFailed);\n', '\n', '    var ethValue = ethBalanceOf[msg.sender];\n', '    require (ethValue != 0);\n', '    ethBalanceOf[msg.sender] = 0;\n', '\n', '    // Refund original Ether amount\n', '    msg.sender.transfer(ethValue);\n', '    Refund(msg.sender, ethValue);\n', '  }\n', '\n', '  // Returns balance raised in ETH from specific address\n', '\tfunction getBalanceInEth(address addr) returns(uint){\n', '\t\treturn ethBalanceOf[addr];\n', '\t}\n', '\n', '  // Returns balance raised in DGT from specific address\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balanceOf[_owner];\n', '  }\n', '\n', '\t// Get remaining supply of DGT\n', '\tfunction getRemainingSupply() returns(uint) {\n', '\t\treturn tokenSupply - allocatedSupply;\n', '\t}\n', '\n', '  // Get raised amount during ICO\n', '  function totalSupply() returns (uint totalSupply) {\n', '    return allocatedSupply;\n', '  }\n', '\n', '  // Upon successfull ICO\n', '  // Allow owner to withdraw funds\n', '  function withdrawFundsToOwner(uint256 _amount) {\n', '    require (icoFulfilled);\n', '    require (this.balance >= _amount);\n', '\n', '    owner.transfer(_amount);\n', '  }\n', '\n', '  // Raised during Pre-sale\n', '  // Since some of the wallets in pre-sale were on exchanges, we transfer tokens\n', '  // to account which will send tokens manually out\n', '\tfunction setPreSaleAmounts() private {\n', '    balanceOf[0x8776A6fA922e65efcEa2371692FEFE4aB7c933AB] += raisedInPresale;\n', '    allocatedSupply += raisedInPresale;\n', '    Transfer(0, 0x8776A6fA922e65efcEa2371692FEFE4aB7c933AB, raisedInPresale);\n', '\t}\n', '\n', '\t// Bounty pool makes up 2% from all tokens bought\n', '\tfunction allocateBountyTokens() private {\n', '    uint256 bountyAmount = allocatedSupply * 100 / 98 * 2 / 100;\n', '\t\tbalanceOf[0x663F98e9c37B9bbA460d4d80ca48ef039eAE4052] += bountyAmount;\n', '    allocatedSupply += bountyAmount;\n', '    Transfer(0, 0x663F98e9c37B9bbA460d4d80ca48ef039eAE4052, bountyAmount);\n', '\t}\n', '}']