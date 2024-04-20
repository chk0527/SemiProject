package com.raon.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.raon.domain.CommentCo;

@Mapper
public interface CommentCoMapper {
	//댓글 작성
	@Insert("insert into comment (bno,content,id) values(#{bno},#{content},#{id})")
	public int insert(CommentCo comment);
	
	//댓글 조회
	@Select("select * from comment where commentid=#{commentid}")
	public CommentCo read(Integer commentid);
	
	//댓글 삭제
	@Delete("delete from comment where commentid=#{commentid}")
	public int delete(Integer commentid);
	
	//댓글 수정
	@Update("update comment set content=#{content} where commentid=#{commentid}")
	public int update(CommentCo comment);
	
	//특정 게시물의 댓글 조회
	@Select("select * from comment where bno=#{bno}")
	public List<CommentCo> getListByBno(@Param("bno") Integer bno);
}
