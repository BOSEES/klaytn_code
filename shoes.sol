// Klaytn IDE uses solidity 0.4.24, 0.5.6 versions.
pragma solidity >=0.4.24 <=0.5.6;

//신발의 NFT를 만들 컨트랙트
contract ShoesNFT {
    string name = "True&False";
    string symbol = "TF";
    
    //컨트랙트의 주인. 즉 신발 리셀마켓 플랫폼이 컨트랙트의 주인이다.
    address public owner;
    
    //발행한 토큰의 총 갯수(토큰의 아이디로 활용할 예정)
    uint256 public tokenCount = 0;
    
    //토큰의 오너
    mapping (uint256 => address) public tokenOwner;
    
    //tokenCount를 키값으로 이용한 신발구조체 맵핑;
    mapping (uint256 => Shoes) public shoesBox;
    
    //address의 보유하고있는 토큰 리스트;
    mapping (address => uint256[]) private _ownedTokenList;
    
    constructor() public {
        owner = msg.sender;
    }
    
    //오너만이 사용 할 수있게하는 함수제어자
    modifier onlyOwner(){
    require(msg.sender == owner);
    _;
    }
    
    //신발의 정보를 담을 구조체
    struct Shoes{
        string name; //신발의 이름 예) jordan1
        string model; //신발의 모델(컬러) 예) chicago
        uint16 size; //신발의 사이즈 예) 265
    }
    
    //신발의 정보를 담은 구조체를 이용해 토큰을 발행. 이때 onlyOwner를 이용해 컨트랙트의 주인만 실행 할 수 있게 만듬.
    function mintWithShoesBox(string memory shoesName, string memory shoesModel, uint16 shoesSize) public onlyOwner {
        tokenCount++;
        tokenOwner[tokenCount] = msg.sender;
        shoesBox[tokenCount] = Shoes(shoesName, shoesModel, shoesSize);
        _ownedTokenList[msg.sender].push(tokenCount);
    }
    
    //NFT 토큰 전송하기
    function transferFrom(address to,uint tokenId) public {
        require(msg.sender == tokenOwner[tokenId], "you is not owner!!");
        _removeToken(msg.sender, tokenId);
        _ownedTokenList[to].push(tokenId);
        tokenOwner[tokenId] = to;
    }
    
    //어떠한 주소가 소유하고있는 토큰의 리스트를 콜
    function viewTokenList(address to) public view returns (uint256[] memory) {
        return _ownedTokenList[to];
    }
    
    //전송한 토큰은 삭제하기
    function _removeToken(address target, uint256 tokenId) private {
        for (uint256 i = 0; i < _ownedTokenList[target].length; i++) {
            if(tokenId == _ownedTokenList[target][i]) {
                uint256 swap = _ownedTokenList[target][_ownedTokenList[target].length - 1];
                _ownedTokenList[target][i] = swap;
                break;
            }
        }
        _ownedTokenList[target].pop();
    }
}


// 이 컨트랙트는 리셀시장(플랫폼) 또는 중고신발을 거래시 정가품을 확인하기위한 컨트랙트 입니다.
// 플랫폼에서 정가품 실제 검수 하여 신발에 메타데이터를 담을 토큰을 만들어 검증하기위한 컨트랙트라고 보시면 됩니다.
// 중고거래시 만약 검수가 된 제품(토큰을 발행한) 이라면 블록에 기록된 내용을 토대로 이 제품이 정품이구나를 확인할수 있게 할려고 합니다.
// 문제는 트랜잭션의 해쉬값을 이용해 정가품을 구분해야해 하는데 이건 좀더 공부해보고 결정할 예정입니다.
