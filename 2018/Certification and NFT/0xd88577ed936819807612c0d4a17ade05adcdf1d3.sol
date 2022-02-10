['pragma solidity ^0.4.11;\n', '\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint a, uint b) internal returns (uint) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      revert();\n', '    }\n', '  }\n', '}\n', 'contract ZTRToken{\n', '    function transfer(address _to, uint val);\n', '}\n', '\n', 'contract ZTRTokenSale\n', '{\n', '    using SafeMath for uint;\n', '    mapping (address => uint) public balanceOf;\n', '    mapping (address => uint) public ethBalance;\n', '    address public owner;\n', '    address ZTRTokenContract;\n', '    uint public fundingGoal;\n', '    uint public fundingMax;\n', '    uint public amountRaised;\n', '    uint public start;\n', '    uint public duration;\n', '    uint public deadline;\n', '    uint public unlockTime;\n', '    uint public ZTR_ETH_initial_price;\n', '    uint public ZTR_ETH_extra_price;\n', '    uint public remaining;\n', '    \n', '    modifier admin { if (msg.sender == owner) _; }\n', '    modifier afterUnlock { if(now>unlockTime) _;}\n', '    modifier afterDeadline { if(now>deadline) _;}\n', '    \n', '    function ZTRTokenSale()\n', '    {\n', '        owner = msg.sender;\n', '        ZTRTokenContract = 0x107bc486966eCdDAdb136463764a8Eb73337c4DF;\n', '        fundingGoal = 5000 ether;//funds will be returned if this goal is not met\n', '        fundingMax = 30000 ether;//The max amount that can be raised\n', '        start = 1517702401;//beginning of the token sale\n', '        duration = 3 weeks;//duration of the token sale\n', '        deadline = start + duration;//end of the token sale\n', '        unlockTime = deadline + 16 weeks;//unlock for selfdestruct\n', '        ZTR_ETH_initial_price = 45000;//initial ztr price\n', '        ZTR_ETH_extra_price = 23000;//ztr price after funding goal has been met\n', '        remaining = 800000000000000000000000000;//counter for remaining tokens\n', '    }\n', '    function () payable public//order processing and crediting to escrow\n', '    {\n', '        require(now>start);\n', '        require(now<deadline);\n', '        require(amountRaised + msg.value < fundingMax);//funding hard cap has not been reached\n', '        uint purchase = msg.value;\n', '        ethBalance[msg.sender] = ethBalance[msg.sender].add(purchase);//track the amount of eth contributed for refunds\n', '        if(amountRaised < fundingGoal)//funding goal has not been met yet\n', '        {\n', '            purchase = purchase.mul(ZTR_ETH_initial_price);\n', '            amountRaised = amountRaised.add(msg.value);\n', '            balanceOf[msg.sender] = balanceOf[msg.sender].add(purchase);\n', '            remaining.sub(purchase);\n', '        }\n', '        else//funding goal has been met, selling extra tokens\n', '        {\n', '            purchase = purchase.mul(ZTR_ETH_extra_price);\n', '            amountRaised = amountRaised.add(msg.value);\n', '            balanceOf[msg.sender] = balanceOf[msg.sender].add(purchase);\n', '            remaining.sub(purchase);\n', '        }\n', '    }\n', '    \n', '    function withdrawBeneficiary() public admin afterDeadline//withdrawl for the ZTrust Foundation\n', '    {\n', '        ZTRToken t = ZTRToken(ZTRTokenContract);\n', '        t.transfer(msg.sender, remaining);\n', '        require(amountRaised >= fundingGoal);//allow admin withdrawl if funding goal is reached and the sale is over\n', '        owner.transfer(amountRaised);\n', '    }\n', '    \n', '    function withdraw() afterDeadline//ETH/ZTR withdrawl for sale participants\n', '    {\n', '        if(amountRaised < fundingGoal)//funding goal was not met, withdraw ETH deposit\n', '        {\n', '            uint ethVal = ethBalance[msg.sender];\n', '            ethBalance[msg.sender] = 0;\n', '            msg.sender.transfer(ethVal);\n', '        }\n', '        else//funding goal was met, withdraw ZTR tokens\n', '        {\n', '            uint tokenVal = balanceOf[msg.sender];\n', '            balanceOf[msg.sender] = 0;\n', '            ZTRToken t = ZTRToken(ZTRTokenContract);\n', '            t.transfer(msg.sender, tokenVal);\n', '        }\n', '    }\n', '    \n', '    function setDeadline(uint ti) public admin//setter\n', '    {\n', '        deadline = ti;\n', '    }\n', '    \n', '    function setStart(uint ti) public admin//setter\n', '    {\n', '        start = ti;\n', '    }\n', '    \n', '    function suicide() public afterUnlock //contract can be destroyed 4 months after the sale ends to save state\n', '    {\n', '        selfdestruct(owner);\n', '    }\n', '}']