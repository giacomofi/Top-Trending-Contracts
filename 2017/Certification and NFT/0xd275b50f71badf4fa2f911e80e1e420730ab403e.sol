['pragma solidity ^0.4.18;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', 'contract DragonPricing is Ownable {\n', '    \n', '   \n', '    \n', '    DragonCrowdsaleCore dragoncrowdsalecore;\n', '    uint public firstroundprice  = .000000000083333333 ether;\n', '    uint public secondroundprice = .000000000100000000 ether;\n', '    uint public thirdroundprice  = .000000000116686114 ether;\n', '    \n', '    uint public price;\n', '    \n', '    \n', '    function DragonPricing() {\n', '        \n', '        \n', '        price = firstroundprice;\n', '        \n', '        \n', '    }\n', '    \n', '    \n', '    \n', '    \n', '    function crowdsalepricing( address tokenholder, uint amount, uint crowdsaleCounter )  returns ( uint , uint ) {\n', '        \n', '        uint award;\n', '        uint donation = 0;\n', '        return ( DragonAward ( amount, crowdsaleCounter ) ,donation );\n', '        \n', '    }\n', '    \n', '    \n', '    function precrowdsalepricing( address tokenholder, uint amount )   returns ( uint, uint )  {\n', '        \n', '       \n', '        uint award;\n', '        uint donation;\n', '        require ( presalePackage( amount ) == true );\n', '        ( award, donation ) = DragonAwardPresale ( amount );\n', '        \n', '        return ( award, donation );\n', '        \n', '    }\n', '    \n', '    \n', '    function presalePackage ( uint amount ) internal returns ( bool )  {\n', '        \n', '        if( amount != .3333333 ether && amount != 3.3333333 ether && amount != 33.3333333 ether  ) return false;\n', '        return true;\n', '   }\n', '    \n', '    \n', '    function DragonAwardPresale ( uint amount ) internal returns ( uint , uint ){\n', '        \n', '        if ( amount ==   .3333333 ether ) return   (   10800000000 ,   800000000 );\n', '        if ( amount ==  3.3333333 ether ) return   (  108800000000 ,  8800000000 );\n', '        if ( amount == 33.3333333 ether ) return   ( 1088800000000 , 88800000000 );\n', '    \n', '    }\n', '    \n', '    \n', '    \n', '    function DragonAward ( uint amount, uint crowdsaleCounter ) internal returns ( uint  ){\n', '        \n', '       \n', '        //uint crowdsaleCounter  = dragoncrowdsalecore.crowdsaleCounter();\n', '        if ( crowdsaleCounter > 1000000000000000 &&  crowdsaleCounter < 2500000000000000 ) price = secondroundprice;\n', '        if ( crowdsaleCounter >= 2500000000000000 ) price = thirdroundprice;\n', '          \n', '        return ( amount / price );\n', '          \n', '    \n', '    }\n', '    \n', '  \n', '    \n', '    function setFirstRoundPricing ( uint _pricing ) onlyOwner {\n', '        \n', '        firstroundprice = _pricing;\n', '        \n', '    }\n', '    \n', '    function setSecondRoundPricing ( uint _pricing ) onlyOwner {\n', '        \n', '        secondroundprice = _pricing;\n', '        \n', '    }\n', '    \n', '    function setThirdRoundPricing ( uint _pricing ) onlyOwner {\n', '        \n', '        thirdroundprice = _pricing;\n', '        \n', '    }\n', '    \n', '    \n', '}\n', '\n', 'contract Dragon {\n', '    function transfer(address receiver, uint amount)returns(bool ok);\n', '    function balanceOf( address _address )returns(uint256);\n', '}\n', '\n', '\n', '\n', '\n', '\n', 'contract DragonCrowdsaleCore is Ownable, DragonPricing {\n', '    \n', '    using SafeMath for uint;\n', '    \n', '   // address public owner;\n', '    address public beneficiary;\n', '    address public charity;\n', '    address public advisor;\n', '    address public front;\n', '    bool public advisorset;\n', '    \n', '    uint public tokensSold;\n', '    uint public etherRaised;\n', '    uint public presold;\n', '    uint public presoldMax;\n', '    \n', '    uint public crowdsaleCounter;\n', '    \n', '   \n', '    uint public advisorTotal;\n', '    uint public advisorCut;\n', '    \n', '    Dragon public tokenReward;\n', '    \n', '   \n', '    \n', '    mapping ( address => bool ) public alreadyParticipated;\n', '    \n', '    \n', '    \n', '  \n', '    \n', '    modifier onlyFront() {\n', '       require (msg.sender == front );\n', '        _;\n', '    }\n', '\n', '\n', '    \n', '    \n', '    \n', '    function DragonCrowdsaleCore(){\n', '        \n', '        tokenReward = Dragon( 0x814f67fa286f7572b041d041b1d99b432c9155ee ); // Dragon Token Address\n', '        owner = msg.sender;\n', '        beneficiary = msg.sender;\n', '        charity = msg.sender;\n', '        advisor = msg.sender;\n', '       \n', '        advisorset = false;\n', '       \n', '        presold = 0;\n', '        presoldMax = 3500000000000000;\n', '        crowdsaleCounter = 0;\n', '        \n', '        advisorCut = 0;\n', '        advisorTotal = 1667 ether;\n', '        \n', '        \n', '    }\n', '    \n', '   \n', '    // runs during precrowdsale - can only be called by main crowdsale contract\n', '    function precrowdsale ( address tokenholder ) onlyFront payable {\n', '        \n', '        \n', '        require ( presold < presoldMax );\n', '        uint award;  // amount of dragons to credit to tokenholder\n', '        uint donation; // donation to charity\n', '        require ( alreadyParticipated[ tokenholder ]  != true ) ;  \n', '        alreadyParticipated[ tokenholder ] = true;\n', '        \n', '        DragonPricing pricingstructure = new DragonPricing();\n', '        ( award, donation ) = pricingstructure.precrowdsalepricing( tokenholder , msg.value ); \n', '        \n', '        tokenReward.transfer ( charity , donation ); // send dragons to charity\n', '        presold = presold.add( award ); //add number of tokens sold in presale\n', '        presold = presold.add( donation ); //add number of tokens sent via charity\n', '        \n', '        tokensSold = tokensSold.add(donation);  //add charity donation to total number of tokens sold \n', '        tokenReward.transfer ( tokenholder , award ); // immediate transfer of dragons to token buyer\n', '        \n', '        if ( advisorCut < advisorTotal ) { advisorSiphon();} \n', '       \n', '        else \n', '          { beneficiary.transfer ( msg.value ); } //send ether to beneficiary\n', '          \n', '       \n', '        etherRaised = etherRaised.add( msg.value ); // tallies ether raised\n', '        tokensSold = tokensSold.add(award); // tallies total dragons sold\n', '        \n', '    }\n', '    \n', '    // runs when crowdsale is active - can only be called by main crowdsale contract\n', '    function crowdsale ( address tokenholder  ) onlyFront payable {\n', '        \n', '        \n', '        uint award;  // amount of dragons to send to tokenholder\n', '        uint donation; // donation to charity\n', '        DragonPricing pricingstructure = new DragonPricing();\n', '        ( award , donation ) = pricingstructure.crowdsalepricing( tokenholder, msg.value, crowdsaleCounter ); \n', '         crowdsaleCounter += award;\n', '        \n', '        tokenReward.transfer ( tokenholder , award ); // immediate transfer to token holders\n', '       \n', '        if ( advisorCut < advisorTotal ) { advisorSiphon();} // send advisor his share\n', '       \n', '        else \n', '          { beneficiary.transfer ( msg.value ); } //send all ether to beneficiary\n', '        \n', '        etherRaised = etherRaised.add( msg.value );  //etherRaised += msg.value; // tallies ether raised\n', '        tokensSold = tokensSold.add(award); //tokensSold  += award; // tallies total dragons sold\n', '       \n', '        \n', '        \n', '    }\n', '    \n', '    \n', '    // pays the advisor part of the incoming ether\n', '    function advisorSiphon() internal {\n', '        \n', '         uint share = msg.value/10;\n', '         uint foradvisor = share;\n', '             \n', '           if ( (advisorCut + share) > advisorTotal ) foradvisor = advisorTotal.sub( advisorCut ); \n', '             \n', '           advisor.transfer ( foradvisor );  // advisor gets 10% of the incoming ether\n', '            \n', '           advisorCut = advisorCut.add( foradvisor );\n', '           beneficiary.transfer( share * 9 ); // the ether balance goes to the benfeciary\n', '           if ( foradvisor != share ) beneficiary.transfer( share.sub(foradvisor) ); // if 10% of the incoming ether exceeds the total advisor is supposed to get , then this gives them a smaller share to not exceed max\n', '        \n', '        \n', '        \n', '    }\n', '    \n', '   \n', '\n', '    \n', '    // use this to set the crowdsale beneficiary address\n', '    function transferBeneficiary ( address _newbeneficiary ) onlyOwner {\n', '        \n', '        require ( _newbeneficiary != 0x00 );\n', '        beneficiary = _newbeneficiary;\n', '        \n', '    }\n', '    \n', '    // use this to set the charity address\n', '    function transferCharity ( address _charity ) onlyOwner {\n', '        \n', '        require ( _charity != 0x00 );\n', '        charity = _charity;\n', '        \n', '    }\n', '    \n', '    // sets crowdsale address\n', '    function setFront ( address _front ) onlyOwner {\n', '        \n', '        require ( _front != 0x00 );\n', '        front = _front;\n', '        \n', '    }\n', '    // sets advisors address\n', '    function setAdvisor ( address _advisor ) onlyOwner {\n', '        \n', '        require ( _advisor != 0x00 );\n', '        require ( advisorset == false );\n', '        advisorset = true;\n', '        advisor = _advisor;\n', '        \n', '    }\n', '    \n', '   \n', '        \n', '    //empty the crowdsale contract of Dragons and forward balance to beneficiary\n', '    function withdrawCrowdsaleDragons() onlyOwner{\n', '        \n', '        uint256 balance = tokenReward.balanceOf( address( this ) );\n', '        tokenReward.transfer( beneficiary, balance );\n', '        \n', '        \n', '    }\n', '    \n', '    //manually send different dragon packages\n', '    function manualSend ( address tokenholder, uint packagenumber ) onlyOwner {\n', '        \n', '          require ( tokenholder != 0x00 );\n', '          if ( packagenumber != 1 &&  packagenumber != 2 &&  packagenumber != 3 ) revert();\n', '        \n', '          uint award;\n', '          uint donation;\n', '          \n', '          if ( packagenumber == 1 )  { award =   10800000000; donation =   800000000; }\n', '          if ( packagenumber == 2 )  { award =  108800000000; donation =  8800000000; }\n', '          if ( packagenumber == 3 )  { award = 1088800000000; donation = 88800000000; }\n', '          \n', '          \n', '          tokenReward.transfer ( tokenholder , award ); \n', '          tokenReward.transfer ( charity , donation ); \n', '          \n', '          presold = presold.add( award ); //add number of tokens sold in presale\n', '          presold = presold.add( donation ); //add number of tokens sent via charity\n', '          tokensSold = tokensSold.add(award); // tallies total dragons sold\n', '          tokensSold = tokensSold.add(donation); // tallies total dragons sold\n', '        \n', '    }\n', '   \n', '   \n', '    \n', '    \n', '    \n', '}']