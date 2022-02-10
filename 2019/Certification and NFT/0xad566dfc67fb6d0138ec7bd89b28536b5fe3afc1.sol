['pragma solidity >=0.5.8;\n', '/*\n', 'MMMMZ$..?ZOMMMMMMMMMMMMMMMMMOZ?~~IZMMMMM\n', 'MMMZ~.~~,..ZOMMMMMMMMMMMMMDZ~~~~~~+ZMMMM\n', 'MMDZ.~====~.:ZMMMMMMMMMMMO7~======~$8MMM\n', 'MMO.,=======.:7~.......+$=~=======~~OMMM\n', 'MMO.=====...............~~~~~~=====~ZMMM\n', 'MMZ.==~.................~~~~~~~~===~ZMMM\n', 'MMO.=~..................:~~~~~~~~~~~ZMMM\n', 'MMO......................~~~~~~~~~~~OMMM\n', 'MMMZ......................:~~~~~~~~OMMMM\n', 'MMO+........................~~~~~~~ZDMMM\n', 'MMO............................:~~~~ZMMM\n', 'MO~......:ZZ,.............ZZ:.......ZMMM\n', 'MO......+ZZZZ,...........ZZZZ+......7DMM\n', 'MDZ?7=...ZZZZ............OZZZ.......ZMMM\n', 'O+....Z==........ZZ~Z.......====.?ZZZ8MM\n', ',....Z,$....................,==~.ZODMMMM\n', 'Z.O.=ZZ.......................7OZOZDMMMM\n', 'O.....:ZZZ~,................I$.....OMMMM\n', '8=.....ZZI??ZZZOOOZZZZZOZZZ?O.Z.:~.ZZMMM\n', 'MZ.......+7Z7????$OZZI????Z~~ZOZZZZ~~$OM\n', 'MMZ...........IZO~~~~~ZZ?.$~~~~~~~~~~~ZM\n', 'MMMO7........==Z=~~~~~~O=+I~~IIIZ?II~~IN\n', 'MMMMMZ=.....:==Z~~~Z~~+$=+I~~ZZZZZZZ~~IN\n', 'MMMMDZ.+Z...====Z+~~~$Z==+I~~~~$Z+OZ~~IN\n', 'MMMMO....O=.=====~I$?====+I~~ZZ?+Z~~~~IN\n', 'MMMMZ.....Z~=============+I~~$$$Z$$$~~IN\n', 'MMMMZ......O.============OI~ZZZZZZZZZ~IN\n', 'MMMMZ,.....~7..,=======,.ZI~Z?~OZZ~IZ~IN\n', 'MMMZZZ......O...........7+$~~~~~~~~~~~ZM\n', 'MMZ,........ZI:.........$~$=~~~~~~~~~7OM\n', 'MMOZ,Z.,?$Z8MMMMND888DNMMNZZZZZZZZZOOMMM\n', 'MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNMMMMMMMM\n', '\n', 'This is the generic Manek.io wager contract. With a standard end timer. Betting\n', 'can only be stared by the admin. Who sets an endtime and number of picks.\n', 'Bettingcan only be ended once the timer is over. Players must withdraw their\n', 'funds once betting is over. This can be done on Manek.io or via the abi which\n', 'will always be publicly available. There is a single jackpot winner which is\n', 'based off the hash of the block 200 before betting ends and will be valid for 6000\n', 'blocks (about 1 day). The jackpot winner must claim their prize or it will\n', 'go to the next winner.\n', '*/\n', '\n', 'contract manekio {\n', '\n', '  //EVENTS\n', '  event playerBet (\n', '    address indexed playerAddress,\n', '    uint256 pick,\n', '    uint256 eth\n', '    );\n', '    //MODIFIERS\n', '    modifier onlyAdministrator(){\n', '      address _playerAddress = msg.sender;\n', '      require(_playerAddress == admin);\n', '      _;\n', '    }\n', '    //STRUCTURES\n', '    struct playerJBook {\n', '      uint256 sShare;\n', '      uint256 eShare;\n', '    }\n', '    struct playerBook {\n', '      uint256 share;\n', '      bool paid;\n', '    }\n', '    struct pickBook {\n', '      uint256 share; //number of shares in each\n', '      uint256 nBet; //number of player bets (ID)\n', '    }\n', '\n', '    //DATASETS\n', '    mapping(address => mapping(uint256 => playerJBook)) internal plyrJBk; //[addr][bet#] = playerJBook addr => bet num => plyrJBk\n', '    mapping(address => mapping(uint256 => playerBook)) internal pAddrxBk; //pAddrxBk[addr][pick ID] = shares   address => pick => shares\n', '    mapping(uint256 => pickBook) internal pBk; //total number of N bets & shares\n', '    uint256 internal tShare = 0;\n', '    uint256 internal pot = 0;\n', '    uint256 internal comm = 0;\n', '    uint256 internal commrate = 25;\n', '    uint256 internal commPaid = 0;\n', '    uint256 internal jackpot = 0;\n', '    uint256 internal jpotrate = 25;\n', '    uint256 internal jpotinterval = 6000;\n', '    bool internal ended = false;\n', '    address payable internal admin = 0xe7Cef4D90BdA19A6e2A20F12A1A6C394230d2924;\n', '    //set by admin when starting betting\n', '    uint256 internal endtime = 0;\n', '    bool internal started = false;\n', '    uint256 internal pcknum; //number of picks 0 to x\n', '    //end of game values\n', '    uint256 internal wPck = 999; //winning pick is initialized as 999\n', '    uint256 internal shareval = 0;\n', '    uint256 internal endblock = 0; //block number that betting is ended on\n', '    uint256 internal jendblock = 0;\n', '    uint256 internal endblockhash = 0;\n', '    address payable internal jPotWinner;\n', '    bool internal jPotclaimed = false;\n', '\n', '    //FALLBACK FUNCTION\n', '    //all eth sent to contract without proper message will dump into pot, comm, and jackpot\n', '    function() external payable {\n', '      require(msg.value > 0);\n', '      playerPick(pcknum + 1);\n', '    }\n', '    //PUBLIC FUNCTIONS\n', '    //this is where players place their bets\n', '    function playerPick(uint256 _pck) public payable {\n', '      address payable _pAddr = msg.sender;\n', '      uint256 _eth = msg.value;\n', '      require(_eth > 0 && _pck >= 0 && _pck < 999);\n', '      //minimum bet entry is .01 eth & player chose a valid pick\n', '      if (_eth >= 1e16 && !checkTime() && !ended && _pck <= pcknum && started) {\n', '        //get my fucking money\n', '        uint256 _commEth = _eth / commrate;\n', '        uint256 _jpEth = _eth / jpotrate;\n', '        comm += _commEth;\n', '        jackpot += _jpEth;\n', '        uint256 _potEth = _eth - _commEth - _jpEth;\n', '        //inc pot\n', '        pot += _potEth;\n', '        //calc shares (each share is .00001 eth)\n', '        uint256 _share = _potEth / 1e13;\n', '        //update books\n', '        pBk[_pck].nBet += 1;\n', '        pBk[_pck].share += _share;\n', '        //update plyrJBk\n', '        for(uint256 i = 0; true; i++) {\n', '          if(plyrJBk[_pAddr][i].eShare == 0){\n', '            plyrJBk[_pAddr][i].sShare = tShare;\n', '            plyrJBk[_pAddr][i].eShare = tShare + _share - 1;\n', '            break;\n', '          }\n', '        }\n', '        //update total shares\n', '        tShare += _share;\n', '        //update pAddrxBk\n', '        pAddrxBk[_pAddr][_pck].share += _share;\n', '        //fire event\n', '        emit playerBet(_pAddr, _pck, _potEth);\n', '      }\n', "      //you go here if you didn't send enough eth, didn't choose a valid pick, or the betting hasnt started yet\n", '      else if (!started || !ended) {\n', '        uint256 _commEth = _eth / commrate;\n', '        uint256 _jpEth = _eth / jpotrate;\n', '        comm += _commEth;\n', '        jackpot += _jpEth;\n', '        uint256 _potEth = _eth - _commEth - _jpEth;\n', '        pot += _potEth;\n', '      }\n', '      //if you really goof. send too little eth or betting is over it goes to admin\n', '      else {\n', '        comm += _eth;\n', '      }\n', '    }\n', '\n', '    function claimJackpot() public {\n', '      address payable _pAddr = msg.sender;\n', '      uint256 _jackpot = jackpot;\n', '      require(ended == true && checkJPotWinner(_pAddr) && !jPotclaimed);\n', '      _pAddr.transfer(_jackpot);\n', '      jPotclaimed = true;\n', '      jPotWinner = _pAddr;\n', '    }\n', '\n', '    function payMeBitch(uint256 _pck) public {\n', '      address payable _pAddr = msg.sender;\n', '      require(_pck >= 0 && _pck < 998);\n', '      require(ended == true && pAddrxBk[_pAddr][_pck].paid == false && pAddrxBk[_pAddr][_pck].share > 0 && wPck == _pck);\n', '      _pAddr.transfer(pAddrxBk[_pAddr][_pck].share * shareval);\n', '      pAddrxBk[_pAddr][_pck].paid = true;\n', '    }\n', '\n', '    //VIEW FUNCTIONS\n', '    function checkJPotWinner(address payable _pAddr) public view returns(bool){\n', '      uint256 _endblockhash = endblockhash;\n', '      uint256 _tShare = tShare;\n', '      uint256 _nend = nextJPot();\n', '      uint256 _wnum;\n', '      require(plyrJBk[_pAddr][0].eShare != 0);\n', '      if (jPotclaimed == true) {\n', '        return(false);\n', '      }\n', '      _endblockhash = uint256(keccak256(abi.encodePacked(_endblockhash + _nend)));\n', '      _wnum = (_endblockhash % _tShare);\n', '      for(uint256 i = 0; true; i++) {\n', '        if(plyrJBk[_pAddr][i].eShare == 0){\n', '          break;\n', '        }\n', '        else {\n', '          if (plyrJBk[_pAddr][i].sShare <= _wnum && plyrJBk[_pAddr][i].eShare >= _wnum ){\n', '            return(true);\n', '          }\n', '        }\n', '      }\n', '      return(false);\n', '    }\n', '\n', '    function nextJPot() public view returns(uint256) {\n', '      uint256 _cblock = block.number;\n', '      uint256 _jendblock = jendblock;\n', '      uint256 _tmp = (_cblock - _jendblock);\n', '      uint256 _nend = _jendblock + jpotinterval;\n', '      uint256 _c = 0;\n', '      if (jPotclaimed == true) {\n', '        return(0);\n', '      }\n', '      while(_tmp > ((_c + 1) * jpotinterval)) {\n', '        _c += 1;\n', '      }\n', '      _nend += jpotinterval * _c;\n', '      return(_nend);\n', '    }\n', '\n', '    //to view postitions on bet for specific address\n', '    function addressPicks(address _pAddr, uint256 _pck) public view returns(uint256) {\n', '      return(pAddrxBk[_pAddr][_pck].share);\n', '    }\n', '    //checks if an address has been paid\n', '    function addressPaid(address _pAddr, uint256 _pck) public view returns(bool) {\n', '      return(pAddrxBk[_pAddr][_pck].paid);\n', '    }\n', '    //get shares in pot for specified pick\n', '    function pickPot(uint256 _pck) public view returns(uint256) {\n', '      return(pBk[_pck].share);\n', '    }\n', '    //get number of bets for speficied pick\n', '    function pickPlyr(uint256 _pck) public view returns(uint256) {\n', '      return(pBk[_pck].nBet);\n', '    }\n', '    //gets the total pot\n', '    function getPot() public view returns(uint256) {\n', '      return(pot);\n', '    }\n', '    //gets the total jackpot\n', '    function getJPot() public view returns(uint256) {\n', '      return(jackpot);\n', '    }\n', '    //gets winning pick set by admin. Will return 999 prior to\n', '    function getWPck() public view returns(uint256) {\n', '      return(wPck);\n', '    }\n', '    function viewJPotclaimed() public view returns(bool) {\n', '      return(jPotclaimed);\n', '    }\n', '    function viewJPotWinner() public view returns(address) {\n', '      return(jPotWinner);\n', '    }\n', '    //grab the time betting is over\n', '    function getEndtime() public view returns(uint256) {\n', '      return(endtime);\n', '    }\n', '    //how much do they owe me?\n', '    function getComm() public view returns(uint256) {\n', '      return(comm);\n', '    }\n', '    function hasStarted() public view returns(bool) {\n', '      return(started);\n', '    }\n', '    function isOver() public view returns(bool) {\n', '      return(ended);\n', '    }\n', '    function pickRatio(uint256 _pck) public view returns(uint256) {\n', '      return(pot / pBk[_pck].share);\n', '    }\n', '    function checkTime() public view returns(bool) {\n', '      uint256 _now = now;\n', '      if (_now < endtime) {\n', '        return(false);\n', '      }\n', '      else {\n', '        return(true);\n', '      }\n', '    }\n', '\n', '    function testView(address _pAddr, uint256 _n) public view returns(uint256 sShare, uint256 eShare) {\n', '      return(plyrJBk[_pAddr][_n].sShare, plyrJBk[_pAddr][_n].eShare);\n', '    }\n', '\n', '    //ADMIN ONLY FUNCTIONS\n', '    function startYourEngines(uint256 _pcknum, uint256 _endtime) onlyAdministrator() public returns(bool){\n', '      require(!started);\n', '      pcknum = _pcknum;\n', '      endtime = _endtime;\n', '      started = true;\n', '      return(true);\n', '    }\n', '    function adminWinner(uint256 _wPck) onlyAdministrator() public {\n', '      require(_wPck <= pcknum && checkTime() && ended == false);\n', '      ended = true;\n', '      wPck = _wPck;\n', '      shareval = pot / pBk[_wPck].share;\n', '      endblock = block.number;\n', '      uint256 _jendblock = block.number;\n', '      jendblock = _jendblock;\n', '      endblockhash = uint256(keccak256(abi.encodePacked(blockhash(_jendblock - 200))));\n', '    }\n', '    function fuckYouPayMe() onlyAdministrator() public {\n', '      uint256 _commDue = comm - commPaid;\n', '      if (_commDue > 0) {\n', '        admin.transfer(_commDue);\n', '        commPaid += _commDue;\n', '      }\n', '    }\n', '  }']