['pragma solidity ^0.4.15;\n', '\n', '\n', 'contract BMICOAffiliateProgramm {\n', '    mapping (string => address) partnersPromo;\n', '    mapping (address => uint256) referrals;\n', '\n', '    struct itemPartners {\n', '        uint256 balance;\n', '        string promo;\n', '        bool create;\n', '    }\n', '    mapping (address => itemPartners) partnersInfo;\n', '\n', '    uint256 public ref_percent = 100; //1 = 0.01%, 10000 = 100%\n', '\n', '\n', '    struct itemHistory {\n', '        uint256 datetime;\n', '        address referral;\n', '        uint256 amount_invest;\n', '    }\n', '    mapping(address => itemHistory[]) history;\n', '\n', '    uint256 public amount_referral_invest;\n', '\n', '    address public owner;\n', '    address public contractPreICO;\n', '    address public contractICO;\n', '\n', '    function BMICOAffiliateProgramm(){\n', '        owner = msg.sender;\n', '        contractPreICO = address(0x0);\n', '        contractICO = address(0x0);\n', '    }\n', '\n', '    modifier isOwner()\n', '    {\n', '        assert(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function str_length(string x) constant internal returns (uint256) {\n', '        bytes32 str;\n', '        assembly {\n', '        str := mload(add(x, 32))\n', '        }\n', '        bytes memory bytesString = new bytes(32);\n', '        uint256 charCount = 0;\n', '        for (uint j = 0; j < 32; j++) {\n', '            byte char = byte(bytes32(uint(str) * 2 ** (8 * j)));\n', '            if (char != 0) {\n', '                bytesString[charCount] = char;\n', '                charCount++;\n', '            }\n', '        }\n', '        return charCount;\n', '    }\n', '\n', '    function changeOwner(address new_owner) isOwner {\n', '        assert(new_owner!=address(0x0));\n', '        assert(new_owner!=address(this));\n', '\n', '        owner = new_owner;\n', '    }\n', '\n', '    function setReferralPercent(uint256 new_percent) isOwner {\n', '        ref_percent = new_percent;\n', '    }\n', '\n', '    function setContractPreICO(address new_address) isOwner {\n', '        assert(contractPreICO==address(0x0));\n', '        assert(new_address!=address(0x0));\n', '        assert(new_address!=address(this));\n', '\n', '        contractPreICO = new_address;\n', '    }\n', '\n', '    function setContractICO(address new_address) isOwner {\n', '        assert(contractICO==address(0x0));\n', '        assert(new_address!=address(0x0));\n', '        assert(new_address!=address(this));\n', '\n', '        contractICO = new_address;\n', '    }\n', '\n', '    function setPromoToPartner(string promo) {\n', '        assert(partnersPromo[promo]==address(0x0));\n', '        assert(partnersInfo[msg.sender].create==false);\n', '        assert(str_length(promo)>0 && str_length(promo)<=6);\n', '\n', '        partnersPromo[promo] = msg.sender;\n', '        partnersInfo[msg.sender].balance = 0;\n', '        partnersInfo[msg.sender].promo = promo;\n', '        partnersInfo[msg.sender].create = true;\n', '    }\n', '\n', '    function checkPromo(string promo) constant returns(bool){\n', '        return partnersPromo[promo]!=address(0x0);\n', '    }\n', '\n', '    function checkPartner(address partner_address) constant returns(bool isPartner, string promo){\n', '        isPartner = partnersInfo[partner_address].create;\n', '        promo = &#39;-1&#39;;\n', '        if(isPartner){\n', '            promo = partnersInfo[partner_address].promo;\n', '        }\n', '    }\n', '\n', '    function calc_partnerPercent(uint256 ref_amount_invest) constant internal returns(uint16 percent){\n', '        percent = 0;\n', '        if(ref_amount_invest > 0){\n', '            if(ref_amount_invest < 2 ether){\n', '                percent = 100; //1 = 0.01%, 10000 = 100%\n', '            }\n', '            else if(ref_amount_invest >= 2 ether && ref_amount_invest < 3 ether){\n', '                percent = 200;\n', '            }\n', '            else if(ref_amount_invest >= 3 ether && ref_amount_invest < 4 ether){\n', '                percent = 300;\n', '            }\n', '            else if(ref_amount_invest >= 4 ether && ref_amount_invest < 5 ether){\n', '                percent = 400;\n', '            }\n', '            else if(ref_amount_invest >= 5 ether){\n', '                percent = 500;\n', '            }\n', '        }\n', '    }\n', '\n', '    function partnerInfo(address partner_address) constant internal returns(string promo, uint256 balance, uint256[] h_datetime, uint256[] h_invest, address[] h_referrals){\n', '        if(partner_address != address(0x0) && partnersInfo[partner_address].create){\n', '            promo = partnersInfo[partner_address].promo;\n', '            balance = partnersInfo[partner_address].balance;\n', '\n', '            h_datetime = new uint256[](history[partner_address].length);\n', '            h_invest = new uint256[](history[partner_address].length);\n', '            h_referrals = new address[](history[partner_address].length);\n', '\n', '            for(uint256 i=0; i<history[partner_address].length; i++){\n', '                h_datetime[i] = history[partner_address][i].datetime;\n', '                h_invest[i] = history[partner_address][i].amount_invest;\n', '                h_referrals[i] = history[partner_address][i].referral;\n', '            }\n', '        }\n', '        else{\n', '            promo = &#39;-1&#39;;\n', '            balance = 0;\n', '            h_datetime = new uint256[](0);\n', '            h_invest = new uint256[](0);\n', '            h_referrals = new address[](0);\n', '        }\n', '    }\n', '\n', '    function partnerInfo_for_Partner(bytes32 hash, uint8 v, bytes32 r, bytes32 s) constant returns(string, uint256, uint256[], uint256[], address[]){\n', '        address partner_address = ecrecover(hash, v, r, s);\n', '        return partnerInfo(partner_address);\n', '    }\n', '\n', '    function partnerInfo_for_Owner (address partner, bytes32 hash, uint8 v, bytes32 r, bytes32 s) constant returns(string, uint256, uint256[], uint256[], address[]){\n', '        if(owner == ecrecover(hash, v, r, s)){\n', '            return partnerInfo(partner);\n', '        }\n', '        else {\n', '            return (&#39;-1&#39;, 0, new uint256[](0), new uint256[](0), new address[](0));\n', '        }\n', '    }\n', '\n', '    function add_referral(address referral, string promo, uint256 amount) external returns(address partner, uint256 p_partner, uint256 p_referral){\n', '        p_partner = 0;\n', '        p_referral = 0;\n', '        partner = address(0x0);\n', '        if (msg.sender == contractPreICO || msg.sender == contractICO){\n', '            if(partnersPromo[promo] != address(0x0) && partnersPromo[promo] != referral){\n', '                partner = partnersPromo[promo];\n', '                referrals[referral] += amount;\n', '                amount_referral_invest += amount;\n', '                partnersInfo[partner].balance += amount;\n', '                history[partner].push(itemHistory(now, referral, amount));\n', '                p_partner = (amount*uint256(calc_partnerPercent(amount)))/10000;\n', '                p_referral = (amount*ref_percent)/10000;\n', '            }\n', '        }\n', '    }\n', '}']
['pragma solidity ^0.4.15;\n', '\n', '\n', 'contract BMICOAffiliateProgramm {\n', '    mapping (string => address) partnersPromo;\n', '    mapping (address => uint256) referrals;\n', '\n', '    struct itemPartners {\n', '        uint256 balance;\n', '        string promo;\n', '        bool create;\n', '    }\n', '    mapping (address => itemPartners) partnersInfo;\n', '\n', '    uint256 public ref_percent = 100; //1 = 0.01%, 10000 = 100%\n', '\n', '\n', '    struct itemHistory {\n', '        uint256 datetime;\n', '        address referral;\n', '        uint256 amount_invest;\n', '    }\n', '    mapping(address => itemHistory[]) history;\n', '\n', '    uint256 public amount_referral_invest;\n', '\n', '    address public owner;\n', '    address public contractPreICO;\n', '    address public contractICO;\n', '\n', '    function BMICOAffiliateProgramm(){\n', '        owner = msg.sender;\n', '        contractPreICO = address(0x0);\n', '        contractICO = address(0x0);\n', '    }\n', '\n', '    modifier isOwner()\n', '    {\n', '        assert(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function str_length(string x) constant internal returns (uint256) {\n', '        bytes32 str;\n', '        assembly {\n', '        str := mload(add(x, 32))\n', '        }\n', '        bytes memory bytesString = new bytes(32);\n', '        uint256 charCount = 0;\n', '        for (uint j = 0; j < 32; j++) {\n', '            byte char = byte(bytes32(uint(str) * 2 ** (8 * j)));\n', '            if (char != 0) {\n', '                bytesString[charCount] = char;\n', '                charCount++;\n', '            }\n', '        }\n', '        return charCount;\n', '    }\n', '\n', '    function changeOwner(address new_owner) isOwner {\n', '        assert(new_owner!=address(0x0));\n', '        assert(new_owner!=address(this));\n', '\n', '        owner = new_owner;\n', '    }\n', '\n', '    function setReferralPercent(uint256 new_percent) isOwner {\n', '        ref_percent = new_percent;\n', '    }\n', '\n', '    function setContractPreICO(address new_address) isOwner {\n', '        assert(contractPreICO==address(0x0));\n', '        assert(new_address!=address(0x0));\n', '        assert(new_address!=address(this));\n', '\n', '        contractPreICO = new_address;\n', '    }\n', '\n', '    function setContractICO(address new_address) isOwner {\n', '        assert(contractICO==address(0x0));\n', '        assert(new_address!=address(0x0));\n', '        assert(new_address!=address(this));\n', '\n', '        contractICO = new_address;\n', '    }\n', '\n', '    function setPromoToPartner(string promo) {\n', '        assert(partnersPromo[promo]==address(0x0));\n', '        assert(partnersInfo[msg.sender].create==false);\n', '        assert(str_length(promo)>0 && str_length(promo)<=6);\n', '\n', '        partnersPromo[promo] = msg.sender;\n', '        partnersInfo[msg.sender].balance = 0;\n', '        partnersInfo[msg.sender].promo = promo;\n', '        partnersInfo[msg.sender].create = true;\n', '    }\n', '\n', '    function checkPromo(string promo) constant returns(bool){\n', '        return partnersPromo[promo]!=address(0x0);\n', '    }\n', '\n', '    function checkPartner(address partner_address) constant returns(bool isPartner, string promo){\n', '        isPartner = partnersInfo[partner_address].create;\n', "        promo = '-1';\n", '        if(isPartner){\n', '            promo = partnersInfo[partner_address].promo;\n', '        }\n', '    }\n', '\n', '    function calc_partnerPercent(uint256 ref_amount_invest) constant internal returns(uint16 percent){\n', '        percent = 0;\n', '        if(ref_amount_invest > 0){\n', '            if(ref_amount_invest < 2 ether){\n', '                percent = 100; //1 = 0.01%, 10000 = 100%\n', '            }\n', '            else if(ref_amount_invest >= 2 ether && ref_amount_invest < 3 ether){\n', '                percent = 200;\n', '            }\n', '            else if(ref_amount_invest >= 3 ether && ref_amount_invest < 4 ether){\n', '                percent = 300;\n', '            }\n', '            else if(ref_amount_invest >= 4 ether && ref_amount_invest < 5 ether){\n', '                percent = 400;\n', '            }\n', '            else if(ref_amount_invest >= 5 ether){\n', '                percent = 500;\n', '            }\n', '        }\n', '    }\n', '\n', '    function partnerInfo(address partner_address) constant internal returns(string promo, uint256 balance, uint256[] h_datetime, uint256[] h_invest, address[] h_referrals){\n', '        if(partner_address != address(0x0) && partnersInfo[partner_address].create){\n', '            promo = partnersInfo[partner_address].promo;\n', '            balance = partnersInfo[partner_address].balance;\n', '\n', '            h_datetime = new uint256[](history[partner_address].length);\n', '            h_invest = new uint256[](history[partner_address].length);\n', '            h_referrals = new address[](history[partner_address].length);\n', '\n', '            for(uint256 i=0; i<history[partner_address].length; i++){\n', '                h_datetime[i] = history[partner_address][i].datetime;\n', '                h_invest[i] = history[partner_address][i].amount_invest;\n', '                h_referrals[i] = history[partner_address][i].referral;\n', '            }\n', '        }\n', '        else{\n', "            promo = '-1';\n", '            balance = 0;\n', '            h_datetime = new uint256[](0);\n', '            h_invest = new uint256[](0);\n', '            h_referrals = new address[](0);\n', '        }\n', '    }\n', '\n', '    function partnerInfo_for_Partner(bytes32 hash, uint8 v, bytes32 r, bytes32 s) constant returns(string, uint256, uint256[], uint256[], address[]){\n', '        address partner_address = ecrecover(hash, v, r, s);\n', '        return partnerInfo(partner_address);\n', '    }\n', '\n', '    function partnerInfo_for_Owner (address partner, bytes32 hash, uint8 v, bytes32 r, bytes32 s) constant returns(string, uint256, uint256[], uint256[], address[]){\n', '        if(owner == ecrecover(hash, v, r, s)){\n', '            return partnerInfo(partner);\n', '        }\n', '        else {\n', "            return ('-1', 0, new uint256[](0), new uint256[](0), new address[](0));\n", '        }\n', '    }\n', '\n', '    function add_referral(address referral, string promo, uint256 amount) external returns(address partner, uint256 p_partner, uint256 p_referral){\n', '        p_partner = 0;\n', '        p_referral = 0;\n', '        partner = address(0x0);\n', '        if (msg.sender == contractPreICO || msg.sender == contractICO){\n', '            if(partnersPromo[promo] != address(0x0) && partnersPromo[promo] != referral){\n', '                partner = partnersPromo[promo];\n', '                referrals[referral] += amount;\n', '                amount_referral_invest += amount;\n', '                partnersInfo[partner].balance += amount;\n', '                history[partner].push(itemHistory(now, referral, amount));\n', '                p_partner = (amount*uint256(calc_partnerPercent(amount)))/10000;\n', '                p_referral = (amount*ref_percent)/10000;\n', '            }\n', '        }\n', '    }\n', '}']
