package controller;

import java.io.IOException;
import java.util.HashMap;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.JasperRunManager;
import net.sf.jasperreports.engine.util.JRLoader;
import persistence.GenericDao;

@WebServlet("/relatorio")
public class RelatorioServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public RelatorioServlet() {
		super();
	}

	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException 
	{
		doPost(request, response);
	}

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		geraRelatorio(request, response);
	}
	private void geraRelatorio(HttpServletRequest request,
			HttpServletResponse response) 
					throws ServletException, IOException 
	{
		String erro = "";
		String cliente = request.getParameter("codcliente");
		String jasper = "WEB-INF/reports/exRelatorio.jasper";
		HashMap<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("cliente", cliente);
		byte[] bytes = null;
		ServletContext context = getServletContext();
		try {
			JasperReport relat = (JasperReport) JRLoader.loadObjectFromFile(context.getRealPath(jasper));
			bytes = JasperRunManager.runReportToPdf(relat, parameter, new GenericDao().getConnection());
		} catch (JRException e) {
			erro = e.getMessage();
		}
		finally 
		{
			if(bytes != null) 
			{
				response.setContentType("application/pdf");
				response.setContentLength(bytes.length);
				ServletOutputStream sos = response.getOutputStream();
				sos.write(bytes);
				sos.flush();
				sos.close();
			}
			else 
			{
				RequestDispatcher reqdisp = request.getRequestDispatcher("index.jsp");
				request.setAttribute("erro", erro);
				reqdisp.forward(request, response);
			}
		}
	}

}
