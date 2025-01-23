package egovframework.mapper;

import java.time.LocalDate;
import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.vo.ReserveVO;

@Mapper
public interface ReserveMapper {
	List<ReserveVO> findByDate(LocalDate date);

    ReserveVO findById(Long id);

    void updateReservationStatus(ReserveVO reserve);
}
