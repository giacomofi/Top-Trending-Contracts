['pragma solidity ^0.4.11;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', 'contract PricingStrategy {\n', '\n', '    using SafeMath for uint;\n', '\n', '    uint public newRateTime;\n', '    uint public rate1;\n', '    uint public rate2;\n', '    uint public minimumWeiAmount;\n', '\n', '    function PricingStrategy(\n', '        uint _newRateTime,\n', '        uint _rate1,\n', '        uint _rate2,\n', '        uint _minimumWeiAmount\n', '    ) {\n', '        require(_newRateTime > 0);\n', '        require(_rate1 > 0);\n', '        require(_rate2 > 0);\n', '        require(_minimumWeiAmount > 0);\n', '\n', '        newRateTime = _newRateTime;\n', '        rate1 = _rate1;\n', '        rate2 = _rate2;\n', '        minimumWeiAmount = _minimumWeiAmount;\n', '    }\n', '\n', '    /** Interface declaration. */\n', '    function isPricingStrategy() public constant returns (bool) {\n', '        return true;\n', '    }\n', '\n', '    /** Calculate the current price for buy in amount. */\n', '    function calculateTokenAmount(uint weiAmount) public constant returns (uint tokenAmount) {\n', '        uint bonusRate = 0;\n', '\n', '        if (weiAmount >= minimumWeiAmount) {\n', '            if (now < newRateTime) {\n', '                bonusRate = rate1;\n', '            } else {\n', '                bonusRate = rate2;\n', '            }\n', '        }\n', '\n', '        return weiAmount.mul(bonusRate);\n', '    }\n', '}']