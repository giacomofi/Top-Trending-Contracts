['pragma solidity ^0.4.11;\n', 'contract FundariaToken {\n', '    uint public totalSupply;\n', '    uint public supplyLimit;\n', '    address public fundariaPoolAddress;\n', '    \n', '    function supplyTo(address, uint);\n', '    function tokenForWei(uint) returns(uint);\n', '    function weiForToken(uint) returns(uint);    \n', '         \n', '}\n', '\n', 'contract FundariaBonusFund {\n', '    function setOwnedBonus() payable {}    \n', '}\n', '\n', 'contract FundariaTokenBuy {\n', '        \n', "    address public fundariaBonusFundAddress;  // address of Fundaria 'bonus fund' contract\n", '    address public fundariaTokenAddress; // address of Fundaria token contract\n', '    \n', '    uint public bonusPeriod = 64 weeks; // bonus period from moment of this contract creating\n', '    uint constant bonusIntervalsCount = 9; // decreasing of bonus share with time\n', '    uint public startTimestampOfBonusPeriod; // when the bonus period starts\n', '    uint public finalTimestampOfBonusPeriod; // when the bonus period ends\n', '    \n', '    // for keeping of data to define bonus share at the moment of calling buy()    \n', '    struct bonusData {\n', '        uint timestamp;\n', '        uint shareKoef;\n', '    }\n', '    \n', '    // array to keep bonus related data\n', '    bonusData[9] bonusShedule;\n', '    \n', '    address creator; // creator address of this contract\n', '    // condition to be creator address to run some functions\n', '    modifier onlyCreator { \n', '        if(msg.sender == creator) _;\n', '    }\n', '    \n', '    function FundariaTokenBuy(address _fundariaTokenAddress) {\n', '        fundariaTokenAddress = _fundariaTokenAddress;\n', '        startTimestampOfBonusPeriod = now;\n', '        finalTimestampOfBonusPeriod = now+bonusPeriod;\n', '        for(uint8 i=0; i<bonusIntervalsCount; i++) {\n', '            // define timestamps of bonus period intervals\n', '            bonusShedule[i].timestamp = finalTimestampOfBonusPeriod-(bonusPeriod*(bonusIntervalsCount-i-1)/bonusIntervalsCount);\n', '            // koef for decreasing bonus share\n', '            bonusShedule[i].shareKoef = bonusIntervalsCount-i;\n', '        }\n', '        creator = msg.sender;\n', '    }\n', '    \n', '    function setFundariaBonusFundAddress(address _fundariaBonusFundAddress) onlyCreator {\n', '        fundariaBonusFundAddress = _fundariaBonusFundAddress;    \n', '    } \n', '    \n', '    // finish bonus if needed (if bonus system not efficient)\n', '    function finishBonusPeriod() onlyCreator {\n', '        finalTimestampOfBonusPeriod = now;    \n', '    }\n', '    \n', '    // if token bought successfuly\n', '    event TokenBought(address buyer, uint tokenToBuyer, uint weiForFundariaPool, uint weiForBonusFund, uint remnantWei);\n', '    \n', '    function buy() payable {\n', '        require(msg.value>0);\n', '        // use Fundaria token contract functions\n', '        FundariaToken ft = FundariaToken(fundariaTokenAddress);\n', '        // should be enough tokens before supply reached limit\n', '        require(ft.supplyLimit()-1>ft.totalSupply());\n', '        // tokens to buyer according to course\n', '        var tokenToBuyer = ft.tokenForWei(msg.value);\n', '        // should be enogh ether for at least 1 token\n', '        require(tokenToBuyer>=1);\n', '        // every second token goes to creator address\n', '        var tokenToCreator = tokenToBuyer;\n', '        uint weiForFundariaPool; // wei distributed to Fundaria pool\n', '        uint weiForBonusFund; // wei distributed to Fundaria bonus fund\n', '        uint returnedWei; // remnant\n', '        // if trying to buy more tokens then supply limit\n', '        if(ft.totalSupply()+tokenToBuyer+tokenToCreator > ft.supplyLimit()) {\n', '            // how many tokens are supposed to buy?\n', '            var supposedTokenToBuyer = tokenToBuyer;\n', '            // get all remaining tokens and devide them between reciepents\n', '            tokenToBuyer = (ft.supplyLimit()-ft.totalSupply())/2;\n', '            // every second token goes to creator address\n', '            tokenToCreator = tokenToBuyer; \n', '            // tokens over limit\n', '            var excessToken = supposedTokenToBuyer-tokenToBuyer;\n', '            // wei to return to buyer\n', '            returnedWei = ft.weiForToken(excessToken);\n', '        }\n', '        \n', '        // remaining wei for tokens\n', '        var remnantValue = msg.value-returnedWei;\n', '        // if bonus period is over\n', '        if(now>finalTimestampOfBonusPeriod) {\n', '            weiForFundariaPool = remnantValue;            \n', '        } else {\n', '            uint prevTimestamp;\n', '            for(uint8 i=0; i<bonusIntervalsCount; i++) {\n', '                // find interval to get needed bonus share\n', '                if(bonusShedule[i].timestamp>=now && now>prevTimestamp) {\n', '                    // wei to be distributed into the Fundaria bonus fund\n', '                    weiForBonusFund = remnantValue*bonusShedule[i].shareKoef/(bonusIntervalsCount+1);    \n', '                }\n', '                prevTimestamp = bonusShedule[i].timestamp;    \n', '            }\n', '            // wei for Fundaria pool\n', '            weiForFundariaPool = remnantValue-weiForBonusFund;           \n', '        }\n', '        // use Fundaria token contract function to distribute tokens to creator address\n', '        ft.supplyTo(creator, tokenToCreator);\n', '        // transfer wei for bought tokens to Fundaria pool\n', '        (ft.fundariaPoolAddress()).transfer(weiForFundariaPool);\n', '        // if we have wei for buyer to be saved in bonus fund\n', '        if(weiForBonusFund>0) {\n', '            FundariaBonusFund fbf = FundariaBonusFund(fundariaBonusFundAddress);\n', '            // distribute bonus wei to bonus fund\n', '            fbf.setOwnedBonus.value(weiForBonusFund)();\n', '        }\n', '        // if have remnant, return it to buyer\n', '        if(returnedWei>0) msg.sender.transfer(returnedWei);\n', '        // use Fundaria token contract function to distribute tokens to buyer\n', '        ft.supplyTo(msg.sender, tokenToBuyer);\n', "        // inform about 'token bought' event\n", '        TokenBought(msg.sender, tokenToBuyer, weiForFundariaPool, weiForBonusFund, returnedWei);\n', '    }\n', '    \n', '    // Prevents accidental sending of ether\n', '    function () {\n', '\t    throw; \n', '    }      \n', '\n', '}']